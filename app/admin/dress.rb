ActiveAdmin.register Dress do
  form :partial => 'admin/dresses/form'

  show do |dress|
    attributes_table do
      row :title
      row :body
      row :slug
      row :seo_title
      row :seo_description
      row :seo_keywords
      row :image do
        ul do
          dress.images.each do |image|
            li do
              image_tag(image.name.url(:admin_show))
            end
          end
        end
      end
    end
    panel 'Category' do
      attributes_table_for dress.category do
        rows :title
      end
    end
    active_admin_comments
  end

  controller do
    def permitted_params
      params.permit dress: [:body, :title, :seo_title, :seo_description, :seo_keywords]
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def update
      @dress = Dress.friendly.find(params[:id])
      params[:image][:name].each {|name| @dress.images << Image.create(name: name)} if params[:image].present?
      @dress.dress_consists.delete_all
      @dress.dress_consists << DressConsist.find(params[:dress][:dress_consist][:material].to_i)
      @dress.dress_consists << DressConsist.find(params[:dress][:dress_consist][:embroidery].to_i)
      @dress.category = Category.find(params[:dress][:category_id].to_i)
      respond_to do |format|
        if @dress.update_attributes(permitted_params[:dress])
          format.html { redirect_to admin_dresses_path, notice: 'Dress was successfully updates.' }
        else
          format.html { render action: 'new', notice: 'Dress not updated.' }
        end
      end
    end

    def create
      @dress = Dress.new(permitted_params[:dress])
      params[:name].each {|name| @dress.images << Image.create(name: name)} if params[:image].present?
      @dress.dress_consists << DressConsist.find(params[:dress][:dress_consist][:material].to_i)
      @dress.dress_consists << DressConsist.find(params[:dress][:dress_consist][:embroidery].to_i)
      @dress.category = Category.find(params[:dress][:category_id].to_i)

      respond_to do |format|
        if @dress.save
          format.html { redirect_to admin_dresses_path, notice: 'Dress was successfully created.' }
        else
          format.html { render action: 'new', notice: 'Dress not created.' }
        end
      end
    end
  end


end

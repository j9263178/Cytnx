#include "UniTensor.hpp"
#include "Tensor.hpp"
namespace cytnx{


        void UniTensor_base::Init(const std::vector<Bond> &bonds, const std::vector<cytnx_int64> &in_labels, const cytnx_int64 &Rowrank,const unsigned int &dtype,const int &device,const bool &is_diag){
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }

        std::vector<cytnx_uint64> UniTensor_base::shape() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        bool      UniTensor_base::is_blockform() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        bool     UniTensor_base::is_contiguous() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        void UniTensor_base::to_(const int &device){
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        boost::intrusive_ptr<UniTensor_base> UniTensor_base::to(const int &device) const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        boost::intrusive_ptr<UniTensor_base> UniTensor_base::clone() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        unsigned int  UniTensor_base::dtype() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
       int          UniTensor_base::device() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        std::string      UniTensor_base::dtype_str() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        std::string     UniTensor_base::device_str() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        boost::intrusive_ptr<UniTensor_base> UniTensor_base::permute(const std::vector<cytnx_int64> &mapper,const cytnx_int64 &Rowrank, const bool &by_label){
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        void UniTensor_base::permute_(const std::vector<cytnx_int64> &mapper, const cytnx_int64 &Rowrank, const bool &by_label){
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }

        void UniTensor_base::contiguous_(){
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        boost::intrusive_ptr<UniTensor_base> UniTensor_base::contiguous(){
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }            
        void UniTensor_base::print_diagram(const bool &bond_info){
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }

        Tensor UniTensor_base::get_block(const cytnx_uint64 &idx) const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        Tensor UniTensor_base::get_block(const std::vector<cytnx_int64> &qnum) const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }
        std::vector<Tensor> UniTensor_base::get_blocks() const{
            cytnx_error_msg(true,"[ERROR] fatal internal, cannot call on a un-initialize UniTensor_base%s","\n");
        }

        std::ostream& operator<<(std::ostream& os, const UniTensor &in){
            printf("Tensor name: %s\n",in.name().c_str());
            if(!in.is_tag()) 
                printf("braket_form : %s\n", in.is_braket_form()?"True":"False");
            
            if(in.is_blockform()){
                std::vector<Tensor> tmp = in.get_blocks();
                for(cytnx_uint64 i=0;i<tmp.size();i++)
                    os << tmp[i] << std::endl;
                
            }else{
                printf("is_diag    : %s\n",in.is_diag()?"True":"False");
                Tensor tmp = in.get_block();
                os << tmp << std::endl;     
            }         

            return os;
        }
        

}


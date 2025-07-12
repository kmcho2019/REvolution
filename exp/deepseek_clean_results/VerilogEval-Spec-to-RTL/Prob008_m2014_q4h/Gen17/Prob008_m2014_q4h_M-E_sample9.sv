module TopModule(input in, output out);
    reg out_reg;
    
    always @(*) begin
        case(in)
            1'b0: out_reg = 1'b0;
            1'b1: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end
    
    assign out = out_reg;
endmodule
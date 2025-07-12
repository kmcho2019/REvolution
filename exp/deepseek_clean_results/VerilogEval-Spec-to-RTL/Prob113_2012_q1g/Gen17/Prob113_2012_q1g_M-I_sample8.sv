module TopModule(
    input [3:0] x,
    output f
);
    reg f_reg;
    
    always @(*) begin
        case(x[3:2])
            2'b00: f_reg = (x[1:0] == 2'b00) || (x[1:0] == 2'b10);
            2'b01: f_reg = 1'b0;
            2'b11: f_reg = (x[1:0] != 2'b10);
            2'b10: f_reg = (x[1:0] != 2'b11);
            default: f_reg = 1'b0;
        endcase
    end
    
    assign f = f_reg;
endmodule
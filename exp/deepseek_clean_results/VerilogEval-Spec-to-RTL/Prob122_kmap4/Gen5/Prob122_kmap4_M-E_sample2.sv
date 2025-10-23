module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Concatenate inputs to form 4-bit address
    wire [3:0] address = {a, b, c, d};
    
    // 16-entry LUT implementing the Karnaugh map
    reg out_reg;
    always @(*) begin
        case (address)
            4'b0000: out_reg = 0;
            4'b0001: out_reg = 1;
            4'b0010: out_reg = 0;
            4'b0011: out_reg = 1;
            4'b0100: out_reg = 1;
            4'b0101: out_reg = 0;
            4'b0110: out_reg = 1;
            4'b0111: out_reg = 0;
            4'b1000: out_reg = 0;
            4'b1001: out_reg = 1;
            4'b1010: out_reg = 0;
            4'b1011: out_reg = 1;
            4'b1100: out_reg = 1;
            4'b1101: out_reg = 0;
            4'b1110: out_reg = 1;
            4'b1111: out_reg = 0;
            default: out_reg = 0;
        endcase
    end
    
    assign out = out_reg;
endmodule
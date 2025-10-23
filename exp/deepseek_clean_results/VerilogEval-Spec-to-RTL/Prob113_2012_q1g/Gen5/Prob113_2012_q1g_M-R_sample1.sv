module TopModule(
    input [3:0] x,
    output f
);
    wire [1:0] sel = x[3:2];
    reg f_reg;
    
    always @(*) begin
        case(sel)
            2'b00: f_reg = ~x[1];  // Covers 0000 and 0010
            2'b11: f_reg = x[1] | ~x[0];  // Covers 1100, 1101, 1111
            2'b10: f_reg = ~x[0] | ~x[1];  // Covers 1000, 1001, 1010
            default: f_reg = 0;  // For 01 case (all zeros)
        endcase
    end
    
    assign f = f_reg;
endmodule
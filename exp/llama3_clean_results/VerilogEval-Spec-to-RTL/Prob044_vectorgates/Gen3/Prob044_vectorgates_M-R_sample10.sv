module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);

    reg [2:0] out_or_bitwise_reg;
    reg out_or_logical_reg;
    reg [5:0] out_not_reg;

    always @(*) begin
        out_or_bitwise_reg = a | b;
        out_or_logical_reg = (a != 3'b000) || (b != 3'b000);
        out_not_reg[5:3] = ~b;
        out_not_reg[2:0] = ~a;
        
        out_or_bitwise = out_or_bitwise_reg;
        out_or_logical = out_or_logical_reg;
        out_not = out_not_reg;
    end

endmodule
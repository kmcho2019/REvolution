module TopModule(
    input [99:0] a,  // 100-bit input
    input [99:0] b,  // 100-bit input
    input sel,
    output [99:0] out  // 100-bit output
);

    always @(*) begin
        case (sel)
            1'b0: out = a;  // If sel is 0, output a
            1'b1: out = b;  // If sel is 1, output b
            default: out = 100'b0;  // Default case, set out to 0
        endcase
    end

endmodule
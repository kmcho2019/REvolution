module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    wire [64:0] temp_result;
    assign temp_result = {1'b0, A} - {1'b0, B};
    assign result = temp_result[63:0];
    assign overflow = temp_result[64];

endmodule
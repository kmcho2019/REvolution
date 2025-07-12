module TopModule #(
    parameter REPLICATION_COUNT = 24,
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    wire sign_bit;
    wire [REPLICATION_COUNT-1:0] repeated_sign_bits;

    assign sign_bit = in[INPUT_WIDTH-1];
    assign repeated_sign_bits = {REPLICATION_COUNT{sign_bit}};
    assign out = {repeated_sign_bits, in};

endmodule
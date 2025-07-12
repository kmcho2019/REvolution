module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [15:0] divisor_ext = {8'b0, B};  // Zero-extended divisor
wire div_by_zero = (B == 8'b0);

// Intermediate remainder wires for each bit stage
wire [15:0] rem [0:15];

// First stage (bit 15)
wire [15:0] rem15 = {15'b0, A[15]};
wire [15:0] sub15 = rem15 - divisor_ext;
assign result[15] = ~div_by_zero & (rem15 >= divisor_ext);
assign rem[15] = result[15] ? sub15 : rem15;

// Generate remaining stages
genvar i;
generate
    for (i = 14; i >= 0; i = i - 1) begin : div_stages
        wire [15:0] rem_in = (i == 14) ? rem[15] : rem[i+1];
        wire [15:0] rem_shift = {rem_in[14:0], A[i]};
        wire [15:0] sub = rem_shift - divisor_ext;
        assign result[i] = ~div_by_zero & (rem_shift >= divisor_ext);
        assign rem[i] = result[i] ? sub : rem_shift;
    end
endgenerate

// Final outputs
assign odd = div_by_zero ? 16'hFFFF : rem[0];
assign result = div_by_zero ? 16'hFFFF : result;

endmodule
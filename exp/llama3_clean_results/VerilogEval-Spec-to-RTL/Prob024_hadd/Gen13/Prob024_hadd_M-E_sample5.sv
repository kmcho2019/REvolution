module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

// Define the lookup table for half adder
logic [1:0] lut_sum [1:0][1:0];
logic [1:0] lut_cout [1:0][1:0];

// Initialize the LUT with precomputed results
initial begin
    lut_sum[0][0] = 1'b0;
    lut_sum[0][1] = 1'b1;
    lut_sum[1][0] = 1'b1;
    lut_sum[1][1] = 1'b0;

    lut_cout[0][0] = 1'b0;
    lut_cout[0][1] = 1'b0;
    lut_cout[1][0] = 1'b0;
    lut_cout[1][1] = 1'b1;
end

// Use the LUT to generate sum and carry-out
always @(*) begin
    sum = lut_sum[a][b];
    cout = lut_cout[a][b];
end

endmodule
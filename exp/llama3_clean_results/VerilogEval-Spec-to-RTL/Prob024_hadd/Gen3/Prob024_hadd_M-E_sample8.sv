module TopModule (
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

logic [1:0] lut_sum [1:0][1:0];
logic [0:0] lut_cout [1:0][1:0];

initial begin
    // Initialize the lookup tables
    lut_sum[0][0] = 2'b00;
    lut_sum[0][1] = 2'b01;
    lut_sum[1][0] = 2'b01;
    lut_sum[1][1] = 2'b10;

    lut_cout[0][0] = 1'b0;
    lut_cout[0][1] = 1'b0;
    lut_cout[1][0] = 1'b0;
    lut_cout[1][1] = 1'b1;
end

always_comb begin
    // Use the lookup tables to determine the sum and carry-out
    sum = lut_sum[a][b][0];
    cout = lut_cout[a][b][0];
end

endmodule
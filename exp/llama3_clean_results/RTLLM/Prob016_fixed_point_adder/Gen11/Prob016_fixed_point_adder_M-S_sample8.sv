module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Directly add the two input operands
wire [N:0] sum;
assign sum = a + b;

// Handle overflow
always @(*) begin
    if (sum[N]) begin
        // Saturate at max value for overflow
        c = {N{1'b1}};
    end else begin
        // Assign the result
        c = sum[N-1:0];
    end
end

endmodule
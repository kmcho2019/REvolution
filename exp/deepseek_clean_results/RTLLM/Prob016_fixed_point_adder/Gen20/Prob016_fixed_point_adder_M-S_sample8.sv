module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16   // Total bits
) (
    input wire signed [N-1:0] a,  // Explicitly signed for clarity
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal register for result
    reg signed [N-1:0] res;

    // Perform fixed-point addition using Verilog's signed arithmetic
    always @(*) begin
        res = a + b;  // Verilog automatically handles sign and binary point alignment
    end

    assign c = res;

endmodule
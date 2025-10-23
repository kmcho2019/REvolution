module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal register for result
    reg [N-1:0] res;

    // Perform fixed-point addition using two's complement arithmetic
    always @(*) begin
        res = a + b;
    end

    assign c = res;

endmodule
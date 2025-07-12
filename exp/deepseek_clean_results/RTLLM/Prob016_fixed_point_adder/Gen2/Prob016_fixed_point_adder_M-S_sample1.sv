module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal register as specified
    reg [N-1:0] res;

    always @(*) begin
        // Direct 2's complement addition
        res = a + b;
        
        // Simple overflow handling by truncation
        c = res;
    end

endmodule
module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output reg overflow
);

    always @(*) begin
        // Direct two's complement addition
        c = a + b;
        
        // Overflow detection
        overflow = (a[N-1] == b[N-1]) && (c[N-1] != a[N-1]);
    end

endmodule
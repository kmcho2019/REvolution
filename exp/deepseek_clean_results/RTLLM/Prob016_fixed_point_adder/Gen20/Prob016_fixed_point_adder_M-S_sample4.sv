module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output reg overflow
);

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Q must be less than N");
            $finish;
        end
    end

    // Internal signals
    wire [N-1:0] sum;
    wire carry_out;

    // Basic two's complement addition
    assign {carry_out, sum} = a + b;

    // Overflow occurs when signs match but result sign differs
    always @(*) begin
        overflow = (a[N-1] == b[N-1]) && (sum[N-1] != a[N-1]);
        c = sum;  // Direct assignment, no saturation
    end

endmodule
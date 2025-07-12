module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    always @(*) begin
        // Direct two's complement subtraction
        c = a - b;
        
        // Explicit zero handling (optional, as subtraction already handles this)
        if (a == b) begin
            c = 0;
        end
    end

endmodule
module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    always @(*) begin
        if (a == b) begin
            c = 0;  // Explicit zero handling
        end
        else begin
            c = a - b;  // Let signed arithmetic handle everything else
        end
    end

endmodule
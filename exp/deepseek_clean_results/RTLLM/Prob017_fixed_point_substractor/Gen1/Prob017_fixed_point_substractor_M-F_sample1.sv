module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    always @(*) begin
        // Perform signed subtraction directly
        c = a - b;
        
        // Explicit zero handling (clear sign bit if result is zero)
        if (c[N-2:0] == 0) begin
            c[N-1] = 1'b0;
        end
    end

endmodule
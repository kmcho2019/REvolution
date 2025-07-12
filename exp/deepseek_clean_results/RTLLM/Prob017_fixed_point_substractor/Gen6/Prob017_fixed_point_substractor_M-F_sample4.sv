module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    always @(*) begin
        // Perform signed subtraction
        c = a - b;
        
        // Handle zero case explicitly
        if (c == 0) begin
            c = 0;
        end
    end

endmodule
module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire [N:0] sum_ext;  // Extended sum for overflow detection
    
    // Perform addition with extended bit for overflow detection
    assign sum_ext = {a[N-1], a} + {b[N-1], b};
    
    always @(*) begin
        // Check for positive overflow (sum > max positive)
        if (~sum_ext[N] && sum_ext[N-1]) begin
            c = {1'b0, {(N-1){1'b1}}};  // Saturate to max positive
        end
        // Check for negative overflow (sum < min negative)
        else if (sum_ext[N] && ~sum_ext[N-1]) begin
            c = {1'b1, {(N-1){1'b0}}};  // Saturate to min negative
        end
        else begin
            c = sum_ext[N-1:0];  // Normal case
        end
    end

endmodule
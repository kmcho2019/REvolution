module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total bit width
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output wire overflow
);

    // Internal signals
    wire [N-1:0] b_neg = ~b + 1;  // Two's complement of b
    wire [N-1:0] direct_sub = a + b_neg;
    wire [N-1:0] swapped_sub = b + (~a + 1);
    
    // Magnitude comparison
    wire a_gt_b;
    generate
        if (Q > 0) begin
            // For fixed-point, compare as signed numbers
            assign a_gt_b = $signed(a) > $signed(b);
        end else begin
            // For integer, simple unsigned comparison
            assign a_gt_b = a > b;
        end
    endgenerate

    // Overflow detection
    assign overflow = (a[N-1] == b[N-1]) && (direct_sub[N-1] != a[N-1]);

    // Result selection logic
    always @(*) begin
        if (a == b) begin
            c = {1'b0, {N-1{1'b0}}};  // Explicit positive zero
        end else if (a[N-1] == b[N-1]) begin
            // Same signs: use direct subtraction
            c = direct_sub;
        end else begin
            // Different signs: select based on magnitude
            c = a_gt_b ? direct_sub : swapped_sub;
        end
    end

endmodule
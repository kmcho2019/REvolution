module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-1:0] a_mag = {1'b0, a[N-2:0]};
    wire [N-1:0] b_mag = {1'b0, b[N-2:0]};

    // Full subtraction result
    wire [N-1:0] full_sub = a_mag - b_mag;
    wire [N-1:0] full_add = a_mag + b_mag;

    // Comparison flags
    wire a_gt_b = (a_mag > b_mag);
    wire a_eq_b = (a_mag == b_mag);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction
            if (a_gt_b) begin
                c = {a_sign, full_sub[N-2:0]};
            end else if (a_eq_b) begin
                c = {N{1'b0}};  // Zero result
            end else begin
                c = {~a_sign, full_sub[N-2:0]};
            end
        end else begin
            // Different sign addition
            if (a_sign) begin
                c = {1'b1, full_add[N-2:0]}; // a negative, b positive
            end else begin
                c = {1'b0, full_add[N-2:0]}; // a positive, b negative
            end
        end

        // Explicit zero handling (synthesis-friendly)
        if (c[N-2:0] == {(N-1){1'b0}}) begin
            c[N-1] = 1'b0;
        end
    end

endmodule
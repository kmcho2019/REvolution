module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire a_eq_b = (a_mag == b_mag);

    // Raw subtraction result
    wire [N-1:0] sub_result = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N-1:0] add_result = {1'b0, a_mag} + {1'b0, b_mag};

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign case: subtract magnitudes
            c[N-2:0] = sub_result[N-2:0];
            c[N-1] = (sub_result[N-1] | sub_result[N-2:0] == 0) ? 1'b0 : a_sign;
        end else begin
            // Different signs: compare magnitudes
            if (a_gt_b) begin
                c[N-2:0] = sub_result[N-2:0];
                c[N-1] = a_sign;
            end else if (a_eq_b) begin
                c = {N{1'b0}};  // Zero result
            end else begin
                c[N-2:0] = sub_result[N-2:0];
                c[N-1] = b_sign;
            end
        end

        // Explicit zero handling
        if (c[N-2:0] == 0) begin
            c[N-1] = 1'b0;
        end
    end

endmodule
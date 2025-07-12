module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    wire signs_equal = (a_sign == b_sign);
    
    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    
    // Temporary results
    wire [N-1:0] sum_res;
    wire [N-1:0] diff_res;
    
    // Absolute value addition (when signs match)
    assign sum_res = {a_sign, a_mag + b_mag};
    
    // Absolute value subtraction (when signs differ)
    assign diff_res = a_gt_b ? {1'b0, a_mag - b_mag} : {1'b1, b_mag - a_mag};
    
    // Overflow detection
    wire overflow = signs_equal && (a_sign != sum_res[N-1]);
    
    // Result selection and overflow handling
    always @(*) begin
        if (signs_equal) begin
            if (overflow) begin
                // Saturate to maximum/minimum representable value
                res = a_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
            end else begin
                res = sum_res;
            end
        end else begin
            res = diff_res;
            // Special case: when magnitudes are equal, result is zero
            if (a_mag == b_mag) res = {1'b0, {(N-1){1'b0}}};
        end
    end
    
    assign c = res;

endmodule
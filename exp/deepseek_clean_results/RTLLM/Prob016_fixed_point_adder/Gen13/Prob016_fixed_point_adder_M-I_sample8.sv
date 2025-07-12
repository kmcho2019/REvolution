module fixed_point_adder #(
    parameter Q = 8,        // Number of fractional bits
    parameter N = 16        // Total number of bits
) (
    input wire [N-1:0] a,  // First operand
    input wire [N-1:0] b,   // Second operand
    output wire [N-1:0] c   // Result
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    
    // Result calculation
    reg [N-1:0] res;
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes and keep sign
            res = {a_sign, a_mag + b_mag};
        end
        else begin
            // Different signs: subtract smaller from larger
            if (a_gt_b) begin
                res = {a_sign, a_mag - b_mag};
            end
            else begin
                res = {b_sign, b_mag - a_mag};
            end
        end
    end
    
    assign c = res;

endmodule
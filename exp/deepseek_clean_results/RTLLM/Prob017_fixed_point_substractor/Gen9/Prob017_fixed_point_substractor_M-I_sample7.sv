module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
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
            // Same sign subtraction
            res = {a_sign, a_mag - b_mag};
        end else begin
            // Different sign - effectively addition
            if (a_gt_b) begin
                res = {a_sign, a_mag + b_mag};
            end else begin
                res = {b_sign, b_mag + a_mag};
            end
        end
        
        // Zero detection and sign handling
        if (res[N-2:0] == 0) begin
            res[N-1] = 1'b0;  // Force positive zero
        end
    end

    assign c = res;

endmodule
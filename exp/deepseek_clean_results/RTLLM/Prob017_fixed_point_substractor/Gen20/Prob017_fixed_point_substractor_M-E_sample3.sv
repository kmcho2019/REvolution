module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal sign-magnitude representation
    reg a_sign, b_sign;
    reg [N-2:0] a_mag, b_mag;
    
    // Comparison and operation signals
    wire mag_equal = (a_mag == b_mag);
    wire a_mag_gt = (a_mag > b_mag);
    wire signs_differ = a_sign ^ b_sign;
    
    // Result components
    reg [N-2:0] res_mag;
    reg res_sign;
    wire res_zero = ~(|res_mag);
    
    // Overflow prediction
    wire potential_overflow = (a_sign == b_sign) && (a_sign != signs_differ);
    
    always @(*) begin
        // Convert to sign-magnitude format
        a_sign = a[N-1];
        b_sign = b[N-1];
        a_mag = a[N-2:0];
        b_mag = b[N-2:0];
        
        // Early zero detection case
        if (mag_equal && signs_differ) begin
            res_mag = 0;
            res_sign = 0;
        end
        else begin
            // Magnitude subtraction with carry-select
            if (a_mag_gt) begin
                res_mag = a_mag - b_mag;
            end else begin
                res_mag = b_mag - a_mag;
            end
            
            // Sign determination
            if (signs_differ) begin
                res_sign = a_sign;
            end else begin
                res_sign = a_mag_gt ? a_sign : ~a_sign;
            end
        end
        
        // Handle overflow by saturation
        if (potential_overflow && !res_zero) begin
            res_mag = {1'b0, {(N-2){1'b1}}};  // Max magnitude
            res_sign = signs_differ ? a_sign : ~a_sign;
        end
        
        // Final output assembly
        c = {res_sign, res_mag};
    end

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

endmodule
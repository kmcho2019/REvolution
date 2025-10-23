module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire a_sign, b_sign;
    wire [N-2:0] a_mag, b_mag;
    reg [N-1:0] res;
    wire op_mode;  // 0: addition, 1: subtraction
    
    // Extract sign and magnitude
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign a_mag = a[N-2:0];
    assign b_mag = b[N-2:0];
    
    // Determine operation mode
    assign op_mode = a_sign ^ b_sign;
    
    // Magnitude comparison
    wire a_gt_b;
    assign a_gt_b = (a_mag > b_mag);
    
    always @(*) begin
        if (op_mode) begin
            // Different signs: subtraction
            if (a_gt_b) begin
                res[N-2:0] = a_mag - b_mag;
                res[N-1] = a_sign;
            end else begin
                res[N-2:0] = b_mag - a_mag;
                res[N-1] = (res[N-2:0] == 0) ? 1'b0 : b_sign;
            end
        end else begin
            // Same signs: addition
            {res[N-1], res[N-2:0]} = {1'b0, a_mag} + {1'b0, b_mag};
            res[N-1] = a_sign;  // Maintain original sign
            
            // Handle overflow
            if (res[N-2:0] < a_mag) begin
                res[N-2:0] = {N-1{1'b1}};  // Saturate to max magnitude
            end
        end
        
        // Final output assignment
        c = res;
    end

endmodule
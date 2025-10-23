module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire clk,      // Clock for pipelining
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Pipeline stage registers
    reg [N-2:0] a_mag, b_mag;
    reg a_sign, b_sign;
    reg [N-2:0] mag_result;
    reg result_sign;
    
    // Stage 1: Convert to sign-magnitude
    always @(posedge clk) begin
        a_sign <= a[N-1];
        b_sign <= b[N-1];
        a_mag <= a_sign ? -a[N-2:0] : a[N-2:0];
        b_mag <= b_sign ? -b[N-2:0] : b[N-2:0];
    end
    
    // Stage 2: Magnitude operations
    always @(posedge clk) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction
            if (a_mag > b_mag) begin
                mag_result <= a_mag - b_mag;
                result_sign <= a_sign;
            end else begin
                mag_result <= b_mag - a_mag;
                result_sign <= ~a_sign;
            end
        end else begin
            // Different sign addition
            mag_result <= a_mag + b_mag;
            result_sign <= a_sign;
        end
        
        // Explicit zero handling
        if (mag_result == 0) result_sign <= 0;
    end
    
    // Stage 3: Convert back to 2's complement
    always @(posedge clk) begin
        c <= {result_sign, result_sign ? -mag_result : mag_result};
    end

endmodule
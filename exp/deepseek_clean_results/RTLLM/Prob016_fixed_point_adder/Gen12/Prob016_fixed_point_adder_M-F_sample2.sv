module fixed_point_adder #(
    parameter Q = 8,      // Number of fractional bits
    parameter N = 16      // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = (a_sign == b_sign);
    
    // Extended precision for calculations
    reg [N:0] temp_res;

    always @(*) begin
        if (signs_equal) begin
            // Same signs: direct addition
            temp_res = {a_sign, a} + {b_sign, b};
            
            // Check for overflow (sign change when signs equal)
            if (temp_res[N] != temp_res[N-1]) begin
                // Saturate to maximum positive or negative
                c = a_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
            end else begin
                c = temp_res[N-1:0];
            end
        end
        else begin
            // Different signs: direct subtraction (safe from overflow)
            temp_res = {a_sign, a} + {b_sign, b}; // Equivalent to a - b
            c = temp_res[N-1:0];
        end
    end

endmodule
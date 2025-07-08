module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: absolute addition
            res[N-2:0] = a_mag + b_mag;
            res[N-1] = a_sign;
            
            // Check for overflow (carry into sign bit)
            if (res[N-2:0] < a_mag) begin
                res = {a_sign, {(N-1){1'b0}}; // Saturate to max magnitude
            end
        end
        else begin
            // Different signs: absolute subtraction
            if (a_mag > b_mag) begin
                res[N-2:0] = a_mag - b_mag;
                res[N-1] = a_sign;
            end
            else if (b_mag > a_mag) begin
                res[N-2:0] = b_mag - a_mag;
                res[N-1] = b_sign;
            end
            else begin
                // Equal magnitudes: result is zero
                res = {1'b0, {(N-1){1'b0}}};
            end
        end
        
        c = res;
    end

endmodule
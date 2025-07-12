module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
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
wire sign_equal = (a_sign == b_sign);

always @(*) begin
    if (sign_equal) begin
        // Addition case
        res[N-2:0] = a_mag + b_mag;
        res[N-1] = a_sign;  // Maintain original sign
        
        // Handle overflow by saturating
        if (res[N-2:0] < a_mag) begin  // Overflow occurred
            res[N-2:0] = {1'b0, {(N-2){1'b1}}};  // Max positive magnitude
            res[N-1] = a_sign;
        end
    end
    else begin
        // Subtraction case
        if (a_mag > b_mag) begin
            res[N-2:0] = a_mag - b_mag;
            res[N-1] = a_sign;
        end
        else if (b_mag > a_mag) begin
            res[N-2:0] = b_mag - a_mag;
            res[N-1] = b_sign;
        end
        else begin  // Equal magnitude
            res = {N{1'b0}};  // Zero result
        end
    end
    
    // Assign final result
    c = res;
end

endmodule
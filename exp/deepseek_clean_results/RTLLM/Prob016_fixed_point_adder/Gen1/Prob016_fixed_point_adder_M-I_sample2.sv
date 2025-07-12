module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (default 8)
    parameter N = 16   // Total number of bits (default 16)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

// Internal signals
wire a_sign = a[N-1];
wire b_sign = b[N-1];
wire [N-1:0] a_mag = {1'b0, a[N-2:0]};  // Zero-extended magnitude
wire [N-1:0] b_mag = {1'b0, b[N-2:0]};
wire sign_equal = (a_sign == b_sign);
wire [N-1:0] sum, diff;
wire [N-1:0] abs_diff;

always @(*) begin
    // Calculate sum and absolute difference
    sum = a_mag + b_mag;
    abs_diff = (a_mag > b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);
    
    // Determine result based on sign equality
    if (sign_equal) begin
        // Addition case
        c[N-1] = a_sign;
        // Handle overflow by saturating to maximum magnitude
        if (sum[N-1]) begin  // Overflow occurred
            c[N-2:0] = {(N-1){1'b1}};  // Max magnitude
        end else begin
            c[N-2:0] = sum[N-2:0];
        end
    end
    else begin
        // Subtraction case
        if (a_mag > b_mag) begin
            c[N-1] = a_sign;
            c[N-2:0] = abs_diff[N-2:0];
        end
        else if (b_mag > a_mag) begin
            c[N-1] = b_sign;
            c[N-2:0] = abs_diff[N-2:0];
        end
        else begin  // Equal magnitude
            c = {N{1'b0}};  // Zero result
        end
    end
end

endmodule
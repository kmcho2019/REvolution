module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] a_mag, b_mag;
    reg a_sign, b_sign;
    reg [N-1:0] result;
    reg borrow;
    integer i;
    wire is_zero;

    // Sign and magnitude separation
    always @(*) begin
        a_sign = a[N-1];
        b_sign = b[N-1];
        a_mag = a_sign ? -a : a;
        b_mag = b_sign ? -b : b;
    end

    // Zero detection (combinational)
    assign is_zero = (a == b);

    // Bit-serial subtraction with early termination
    always @(*) begin
        result = 0;
        borrow = 0;
        
        if (is_zero) begin
            result = 0;
        end else if (a_sign == b_sign) begin
            // Same sign subtraction
            for (i = 0; i < N; i = i + 1) begin
                result[i] = a_mag[i] ^ b_mag[i] ^ borrow;
                borrow = (~a_mag[i] & b_mag[i]) | 
                         (~a_mag[i] & borrow) | 
                         (b_mag[i] & borrow);
                // Early termination if remaining bits match
                if (i > Q && a_mag[N-1:i+1] == b_mag[N-1:i+1]) break;
            end
            result[N-1] = a_sign; // Maintain original sign
        end else begin
            // Different sign addition
            for (i = 0; i < N; i = i + 1) begin
                result[i] = a_mag[i] ^ b_mag[i] ^ borrow;
                borrow = (a_mag[i] & b_mag[i]) | 
                         (a_mag[i] & borrow) | 
                         (b_mag[i] & borrow);
                // Early termination if remaining bits are zero
                if (i > Q && (a_mag[N-1:i+1] == 0) && (b_mag[N-1:i+1] == 0)) break;
            end
            // Result sign depends on magnitude comparison
            result[N-1] = (a_mag > b_mag) ? a_sign : b_sign;
        end
    end

    // Final output with zero handling
    always @(*) begin
        c = is_zero ? 0 : result;
    end

endmodule
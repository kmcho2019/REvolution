module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Local parameters for better readability
    localparam SIGN_BIT = N-1;
    localparam MAG_BITS = N-1;

    // Internal signals
    wire a_sign = a[SIGN_BIT];
    wire b_sign = b[SIGN_BIT];
    wire [MAG_BITS-1:0] a_mag = a[MAG_BITS-1:0];
    wire [MAG_BITS-1:0] b_mag = b[MAG_BITS-1:0];
    
    // Signed interpretation for easier comparison
    wire signed [MAG_BITS:0] a_signed = {1'b0, a_mag};
    wire signed [MAG_BITS:0] b_signed = {1'b0, b_mag};

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign case - simple subtraction
            c[MAG_BITS-1:0] = a_mag - b_mag;
            c[SIGN_BIT] = (a_mag >= b_mag) ? a_sign : ~a_sign;
        end
        else begin
            // Different sign case - absolute addition
            c[MAG_BITS-1:0] = a_mag + b_mag;
            // Sign determined by magnitude comparison
            if (a_sign) begin
                c[SIGN_BIT] = (a_signed > b_signed) ? 1'b1 : 1'b0;
            end
            else begin
                c[SIGN_BIT] = (a_signed >= b_signed) ? 1'b0 : 1'b1;
            end
        end

        // Explicit zero handling (sign bit 0 when result is 0)
        if (c[MAG_BITS-1:0] == 0) begin
            c[SIGN_BIT] = 1'b0;
        end
    end

endmodule
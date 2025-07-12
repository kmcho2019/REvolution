module fixed_point_subtractor #(
    parameter integer N = 16, // total bits
    parameter integer Q = 8   // fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values (magnitude) of inputs
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Temporary variables for result magnitude and sign
    reg [N-2:0] res_mag;
    reg         res_sign;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: a - b
            // compute signed subtraction treating inputs as signed values
            // Because a and b are in two's complement, direct subtraction works
            // We'll do a - b = a + (-b)
            reg signed [N-1:0] signed_a;
            reg signed [N-1:0] signed_b;
            reg signed [N-1:0] signed_res;

            signed_a = $signed(a);
            signed_b = $signed(b);
            signed_res = signed_a - signed_b;

            // assign magnitude and sign from signed result
            res_sign = signed_res[N-1];
            res_mag = signed_res[N-2:0];
        end else begin
            // Different sign subtraction is effectively addition of magnitudes
            // a - b where signs differ means adding abs values and sign depends on which magnitude is bigger
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = b_sign;
            end
        end

        // Handle zero result explicitly: if magnitude zero, sign = 0
        if (res_mag == 0) begin
            res_sign = 1'b0;
        end

        // Compose result
        res = {res_sign, res_mag};
    end

    always @* begin
        c = res;
    end

endmodule
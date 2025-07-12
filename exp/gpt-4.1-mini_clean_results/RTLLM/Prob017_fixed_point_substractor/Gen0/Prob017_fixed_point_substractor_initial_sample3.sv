module fixed_point_subtractor #(parameter N = 16, parameter Q = 8)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);
    // Internal registers
    reg [N-1:0] res;

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    wire [N-2:0] a_abs = a_sign ? (~a[N-2:0] + 1) : a[N-2:0];
    wire [N-2:0] b_abs = b_sign ? (~b[N-2:0] + 1) : b[N-2:0];

    reg [N-1:0] temp_res;
    reg res_sign;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: subtraction
            // Convert to signed values for subtraction
            // Using two's complement signed subtraction
            // Sign of result same as inputs

            // Perform subtraction of absolute values with sign
            // For subtraction of signed numbers: just do a - b
            // We can just do a - b directly

            temp_res = a - b;
            res_sign = temp_res[N-1];

            // In case temp_res == 0, force sign = 0 below
        end else begin
            // Different sign: add absolute values and determine sign by magnitude

            if (a_abs >= b_abs) begin
                // |a| >= |b|
                temp_res[N-2:0] = a_abs - b_abs;
                temp_res[N-1] = a_sign;
                res_sign = a_sign;
            end else begin
                // |a| < |b|
                temp_res[N-2:0] = b_abs - a_abs;
                temp_res[N-1] = b_sign;
                res_sign = b_sign;
            end
        end

        // Handle zero: when fractional + integer bits are zero, sign bit forced to 0
        if (temp_res[N-2:0] == 0)
            temp_res[N-1] = 1'b0;

        res = temp_res;
    end

    // Output assignment
    always @* begin
        c = res;
    end

endmodule
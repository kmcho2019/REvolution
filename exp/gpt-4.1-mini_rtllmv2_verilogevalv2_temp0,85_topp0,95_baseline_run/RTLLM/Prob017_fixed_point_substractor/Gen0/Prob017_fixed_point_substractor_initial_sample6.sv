module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract magnitude (absolute values)
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Intermediate register to hold result magnitude and sign
    reg [N-1:0] res;
    reg        res_sign;

    // Compare magnitudes
    wire a_greater_equal_b = (a_mag >= b_mag);

    // Extended width for addition/subtraction to avoid overflow
    localparam EXT = N+1;
    reg [EXT-1:0] temp_sub;
    reg [EXT-1:0] temp_add;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract smaller magnitude from larger magnitude
            if (a_greater_equal_b) begin
                temp_sub = {1'b0, a_mag} - {1'b0, b_mag};
                res_sign = a_sign;
            end else begin
                temp_sub = {1'b0, b_mag} - {1'b0, a_mag};
                res_sign = b_sign;
            end
            // Assign magnitude part of subtraction result
            res = temp_sub[N-1:0];
        end else begin
            // Different signs: add magnitudes
            temp_add = {1'b0, a_mag} + {1'b0, b_mag};
            res = temp_add[N-1:0];
            // Result sign depends on magnitude comparison and which is positive
            if (a_greater_equal_b) begin
                res_sign = a_sign; // sign of a
            end else begin
                res_sign = b_sign; // sign of b
            end
        end

        // Handle zero result: if magnitude zero, sign bit is 0
        if (res == 0)
            res_sign = 1'b0;

        // Form final result with sign
        res = res_sign ? (~res + 1'b1) : res;
    end

    assign c = res;

endmodule
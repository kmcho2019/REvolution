module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values (magnitude) by clearing sign bit and if negative, take two's complement
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Wires for addition and subtraction results (one bit wider to detect overflow)
    wire [N-1:0] add_mag = {1'b0, a_mag} + {1'b0, b_mag};  // N bits to hold sum (possible overflow)
    wire [N-1:0] sub_mag_a_b = {1'b0, a_mag} - {1'b0, b_mag}; // a_mag - b_mag
    wire [N-1:0] sub_mag_b_a = {1'b0, b_mag} - {1'b0, a_mag}; // b_mag - a_mag

    // Main combinational logic
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: addition
            // The sum might overflow, but we keep only N-1 bits (ignoring carry out)
            // Sign bit stays same as a_sign and b_sign
            res[N-2:0] = add_mag[N-2:0];
            res[N-1]   = a_sign;
        end else begin
            // Different signs: subtraction of magnitudes
            if (a_mag == b_mag) begin
                // Result is zero
                res = {N{1'b0}};
            end else if (a_mag > b_mag) begin
                // a magnitude larger: result = a_mag - b_mag, sign = a_sign = 0 here (positive)
                res[N-2:0] = sub_mag_a_b[N-2:0];
                // Sign bit is zero if a_sign=0, but since they differ, a_sign must be zero for larger a_mag?
                // Actually a_sign could be 1 or 0; but if a_mag > b_mag and a_sign != b_sign:
                // According to problem statement, if a is greater, result sign is 0 (positive)
                res[N-1] = 1'b0;
            end else begin
                // b magnitude larger: result = b_mag - a_mag, sign depends on result zero or negative
                res[N-2:0] = sub_mag_b_a[N-2:0];
                // Sign bit according to whether result zero or negative:
                // result zero handled above
                // Since b_mag > a_mag, sign of result = sign of b
                res[N-1] = b_sign;
            end
        end
    end

    // Output assignment
    always @(*) begin
        c = res;
    end

endmodule
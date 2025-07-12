module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Static parameter validation
    generate
        if (Q >= N) begin
            invalid_parameter_value invalid();
        end
    endgenerate

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude comparison (without subtraction)
    wire a_gt_b;
    generate
        if (N > 1) begin
            assign a_gt_b = (a[N-2:0] > b[N-2:0]);
        end else begin
            assign a_gt_b = 1'b0; // Single bit case
        end
    endgenerate

    // Main arithmetic operation
    wire [N-1:0] a_mag = a_sign ? -a : a;
    wire [N-1:0] b_mag = b_sign ? -b : b;
    wire [N:0] sum;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign - simple addition
            sum = {a_sign, a} + {b_sign, b};
        end else begin
            // Different signs - subtract smaller from larger
            if (a_gt_b) begin
                sum = {a_sign, a_mag - b_mag};
            end else begin
                sum = {b_sign, b_mag - a_mag};
            end
        end
    end

    // Overflow detection (only when signs match)
    wire overflow = (a_sign == b_sign) && (sum[N] != sum[N-1]);

    // Final result with saturation
    assign c = overflow ? 
               {a_sign, {N-1{~a_sign}}} :  // Saturate to max/min
               sum[N-1:0];

endmodule
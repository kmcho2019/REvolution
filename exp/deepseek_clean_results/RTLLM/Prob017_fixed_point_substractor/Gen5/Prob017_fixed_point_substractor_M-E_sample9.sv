module fixed_point_subtractor #(
    parameter Q = 16,          // Number of fractional bits
    parameter N = 32           // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow,
    output wire underflow
);

// Sign and magnitude decomposition
wire a_sign = a[N-1];
wire b_sign = b[N-1];
wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

// Operation determination
wire op_subtract = ~(a_sign ^ b_sign);  // 1 when signs same (a-b), 0 when different (a+b)

// Magnitude processing
wire [N-1:0] mag_result;  // Extra bit for overflow detection
wire [N-1:0] add_result = {1'b0, a_mag} + {1'b0, b_mag};
wire [N-1:0] sub_result = a_mag >= b_mag ? {1'b0, a_mag - b_mag} : {1'b0, b_mag - a_mag};

assign mag_result = op_subtract ? sub_result : add_result;

// Result sign determination
wire result_sign = 
    (op_subtract) ? 
        (a_mag >= b_mag ? a_sign : ~a_sign) :
        (a_sign & b_sign);  // Only both negative makes sum negative

// Overflow/underflow detection
assign overflow = (mag_result[N-1] & ~op_subtract) |  // Addition overflow
                  (mag_result > {1'b0, {N-1{1'b1}}});  // Magnitude too large
assign underflow = (mag_result == 0) & (a != b);      // Result zero but inputs different

// Final result assembly
assign c = (mag_result[N-1:0] == 0) ? 0 : {result_sign, mag_result[N-2:0]};

endmodule
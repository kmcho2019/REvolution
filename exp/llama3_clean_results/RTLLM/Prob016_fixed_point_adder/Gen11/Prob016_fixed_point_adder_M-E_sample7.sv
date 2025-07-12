module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Sign Extraction Unit (SEU)
wire sign_a = a[N-1];
wire sign_b = b[N-1];
wire same_sign = sign_a == sign_b;
wire diff_sign = ~same_sign;

// Absolute Value Generator (AVG)
wire [N-1:0] abs_a = sign_a ? ~a + 1 : a;
wire [N-1:0] abs_b = sign_b ? ~b + 1 : b;

// Shift-and-Add Unit (SAU)
reg [N-1:0] sa_result;
always @(*) begin
    if (same_sign) begin
        // Add absolute values
        sa_result = abs_a + abs_b;
    end else if (abs_a >= abs_b) begin
        // Subtract b from a
        sa_result = abs_a - abs_b;
    end else begin
        // Subtract a from b
        sa_result = abs_b - abs_a;
    end
end

// Overflow Detection and Correction Unit (ODCU)
wire overflow = sa_result[N] == 1;
reg [N-1:0] odc_result;
always @(*) begin
    if (overflow) begin
        // Apply correction for overflow
        odc_result = {sign_a, {N-1{1'b0}}};
    end else begin
        odc_result = sa_result;
    end
end

// Output Assignment
assign c = odc_result;

endmodule
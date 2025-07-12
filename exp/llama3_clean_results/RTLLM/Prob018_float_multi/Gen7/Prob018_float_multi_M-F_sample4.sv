module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] pipeline_stage; // Pipeline stage counter
reg [23:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [8:0] a_exponent, b_exponent; // Exponents of inputs
reg a_sign, b_sign; // Sign bits of inputs
reg [49:0] product; // Intermediate product of mantissas
reg [23:0] z_mantissa; // Mantissa of result
reg [8:0] z_exponent; // Exponent of result
reg z_sign; // Sign bit of result
reg guard_bit, round_bit, sticky; // Rounding control bits

// Input processing stage
always @(posedge clk) begin
    if (rst) begin
        pipeline_stage <= 3'b000;
        a_mantissa <= 0;
        a_exponent <= 0;
        a_sign <= 0;
        b_mantissa <= 0;
        b_exponent <= 0;
        b_sign <= 0;
    end else if (pipeline_stage == 3'b000) begin
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
        pipeline_stage <= pipeline_stage + 1;
    end
end

// Exponent calculation stage
always @(posedge clk) begin
    if (pipeline_stage == 3'b001) begin
        z_exponent <= a_exponent + b_exponent - 9'b10000000;
        if (z_exponent > 9'b11111110) begin
            z_exponent <= 9'b11111111; // Overflow
        end else if (z_exponent < 9'b1) begin
            z_exponent <= 9'b0; // Underflow
        end
        pipeline_stage <= pipeline_stage + 1;
    end
end

// Mantissa multiplication stage
always @(posedge clk) begin
    if (pipeline_stage == 3'b010) begin
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        pipeline_stage <= pipeline_stage + 1;
    end
end

// Rounding and normalization stage
always @(posedge clk) begin
    if (pipeline_stage == 3'b011) begin
        // Rounding mode: round to nearest
        guard_bit <= product[24];
        round_bit <= product[25];
        sticky <= product[26] | product[27] | product[28] | product[29] | product[30] | product[31] | product[32] | product[33] | product[34] | product[35] | product[36] | product[37] | product[38] | product[39] | product[40] | product[41] | product[42] | product[43] | product[44] | product[45] | product[46] | product[47] | product[48] | product[49];
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= product[48:25] + 1;
        end else begin
            z_mantissa <= product[48:25];
        end
        z_sign <= a_sign ^ b_sign;
        z <= {z_sign, z_exponent, z_mantissa};
        pipeline_stage <= 3'b000; // Reset pipeline stage counter
    end
end

// Special cases handling stage
always @(posedge clk) begin
    if (pipeline_stage == 3'b100) begin
        if (a[31:30] == 2'b11 || b[31:30] == 2'b11) begin // NaN or infinity
            z <= 32'b1; // Result is NaN or infinity
        end else if (a[30:23] == 0 && a[22:0] == 0 && b[30:23] == 0 && b[22:0] == 0) begin // Both inputs are zero
            z <= 32'b0; // Result is zero
        end
        pipeline_stage <= 3'b000; // Reset pipeline stage counter
    end
end

endmodule
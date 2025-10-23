module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire clk,      // Clock for pipelining
    input wire reset_n,  // Active-low reset (optional)
    input wire enable,   // Pipeline enable
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c,
    output reg overflow,  // Overflow flag
    output reg underflow, // Underflow flag
    output reg zero       // Zero result flag
);

    // Constants for boundary checks
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};

    // Stage 1 registers
    reg signed [N-1:0] a_reg, b_reg;
    reg a_sign, b_sign;
    reg signed [N-1:0] raw_diff;

    // Stage 2 signals
    wire diff_sign;
    wire is_zero;
    wire same_sign;

    assign diff_sign = raw_diff[N-1];
    assign is_zero = (raw_diff == 0);
    assign same_sign = (a_sign == b_sign);

    // Pipeline stage 1: Register inputs and compute raw difference
    always @(posedge clk) begin
        if (!reset_n) begin
            a_reg <= 0;
            b_reg <= 0;
            a_sign <= 0;
            b_sign <= 0;
            raw_diff <= 0;
        end else if (enable) begin
            a_reg <= a;
            b_reg <= b;
            a_sign <= a[N-1];
            b_sign <= b[N-1];
            raw_diff <= a - b;
        end
    end

    // Pipeline stage 2: Handle overflow, underflow, and zero
    always @(posedge clk) begin
        if (!reset_n) begin
            c <= 0;
            overflow <= 0;
            underflow <= 0;
            zero <= 1;
        end else if (enable) begin
            // Default assignments
            c <= raw_diff;
            overflow <= 0;
            underflow <= 0;
            zero <= is_zero;

            // Overflow/underflow only possible when signs differ
            if (!same_sign) begin
                if (!a_sign && diff_sign) begin  // Positive - Negative overflow
                    overflow <= (raw_diff[N-1:N-2] == 2'b01); // Check MSBs
                    c <= overflow ? MAX_VAL : raw_diff;
                end
                else if (a_sign && !diff_sign) begin  // Negative - Positive underflow
                    underflow <= (raw_diff[N-1:N-2] == 2'b10); // Check MSBs
                    c <= underflow ? MIN_VAL : raw_diff;
                end
            end

            // Explicit zero handling
            if (is_zero) begin
                c <= 0;
                overflow <= 0;
                underflow <= 0;
            end
        end
    end

endmodule
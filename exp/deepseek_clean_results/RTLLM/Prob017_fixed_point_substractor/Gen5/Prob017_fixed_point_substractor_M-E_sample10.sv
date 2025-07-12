module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire clk,      // Clock for pipelining
    input wire reset_n,  // Active-low reset
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c,
    output reg overflow,  // Overflow flag
    output reg underflow, // Underflow flag
    output reg zero       // Zero result flag
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
    end

    // Stage 1 registers
    reg signed [N-1:0] a_reg, b_reg;
    reg a_sign, b_sign;
    reg signed [N-1:0] raw_diff;

    // Stage 2 signals
    wire signed [N-1:0] max_val = {1'b0, {(N-1){1'b1}}};
    wire signed [N-1:0] min_val = {1'b1, {(N-1){1'b0}}};
    wire diff_sign = raw_diff[N-1];
    wire is_zero = (raw_diff == 0);

    // Pipeline stage 1: Register inputs and compute raw difference
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            a_reg <= 0;
            b_reg <= 0;
            a_sign <= 0;
            b_sign <= 0;
            raw_diff <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            a_sign <= a[N-1];
            b_sign <= b[N-1];
            raw_diff <= a - b;
        end
    end

    // Pipeline stage 2: Handle overflow, underflow, and zero
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            c <= 0;
            overflow <= 0;
            underflow <= 0;
            zero <= 1;
        end else begin
            // Default assignments
            overflow <= 0;
            underflow <= 0;
            zero <= is_zero;

            // Different signs: check for overflow/underflow
            if (a_sign != b_sign) begin
                if (a_sign && !diff_sign) begin
                    // Case: negative - positive = more negative than min
                    if (raw_diff < min_val) begin
                        c <= min_val;
                        underflow <= 1;
                    end else begin
                        c <= raw_diff;
                    end
                end else if (!a_sign && diff_sign) begin
                    // Case: positive - negative = more positive than max
                    if (raw_diff > max_val) begin
                        c <= max_val;
                        overflow <= 1;
                    end else begin
                        c <= raw_diff;
                    end
                end else begin
                    c <= raw_diff;
                end
            end 
            // Same signs: normal subtraction
            else begin
                c <= raw_diff;
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
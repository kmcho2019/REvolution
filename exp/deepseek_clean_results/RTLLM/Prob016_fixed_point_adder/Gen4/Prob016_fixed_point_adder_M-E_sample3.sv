module fixed_point_adder #(
    parameter Q = 8,          // Fractional bits
    parameter N = 16,         // Total bits
    parameter OVERFLOW = 1,   // 0: wrap-around, 1: saturate
    parameter PIPELINE = 0     // 0: combinational, 1: pipelined
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire [N:0] extended_sum;  // Extra bit for overflow detection
    wire overflow_positive, overflow_negative;
    wire sign_a, sign_b;
    reg [N-1:0] res;

    // Optional pipeline registers
    generate
        if (PIPELINE) begin
            reg [N-1:0] a_reg, b_reg;
            always @(posedge clk) begin
                a_reg <= a;
                b_reg <= b;
            end
            assign sign_a = a_reg[N-1];
            assign sign_b = b_reg[N-1];
            assign extended_sum = {a_reg[N-1], a_reg} + {b_reg[N-1], b_reg};
        end else begin
            assign sign_a = a[N-1];
            assign sign_b = b[N-1];
            assign extended_sum = {a[N-1], a} + {b[N-1], b};
        end
    endgenerate

    // Overflow prediction
    assign overflow_positive = (~sign_a & ~sign_b & extended_sum[N]);
    assign overflow_negative = (sign_a & sign_b & ~extended_sum[N]);

    // Main addition logic with overflow handling
    always @(*) begin
        if (OVERFLOW) begin
            // Saturation mode
            if (overflow_positive) begin
                res = {1'b0, {(N-1){1'b1}}};  // Max positive
            end else if (overflow_negative) begin
                res = {1'b1, {(N-1){1'b0}};    // Min negative
            end else begin
                res = extended_sum[N-1:0];     // Normal result
            end
        end else begin
            // Wrap-around mode
            res = extended_sum[N-1:0];
        end

        // Special case: when signs differ, use direct addition
        if (sign_a ^ sign_b) begin
            res = a + b;
        end
    end

    // Final output assignment
    assign c = res;

    // Optional pipeline stage for output
    generate
        if (PIPELINE) begin
            reg [N-1:0] c_reg;
            always @(posedge clk) begin
                c_reg <= res;
            end
            assign c = c_reg;
        end
    endgenerate

endmodule
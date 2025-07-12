module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Enum for state machine
    enum logic [2:0] {IDLE, MULTIPLY, ROUND, OUTPUT} state;

    // Internal signals
    reg [22:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    // Combinational logic for input processing
    assign a_mantissa = a[22:0];
    assign a_exponent = a[30:23];
    assign a_sign = a[31];
    assign b_mantissa = b[22:0];
    assign b_exponent = b[30:23];
    assign b_sign = b[31];

    // State machine logic
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Special cases handling
                    if ((a_exponent == 8'hff && a_mantissa != 0) || (b_exponent == 8'hff && b_mantissa != 0)) begin
                        // NaN
                        z <= 32'h7fc00000;
                        state <= OUTPUT;
                    end else if ((a_exponent == 8'hff && a_mantissa == 0) || (b_exponent == 8'hff && b_mantissa == 0)) begin
                        // Infinity
                        if (a_sign == b_sign) begin
                            z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                        end else begin
                            z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                        end
                        state <= OUTPUT;
                    end else begin
                        state <= MULTIPLY;
                    end
                end
                MULTIPLY: begin
                    // Multiplication stage
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    state <= ROUND;
                end
                ROUND: begin
                    // Rounding and adjustment stage
                    guard_bit <= product[24];
                    round_bit <= product[25];
                    sticky <= |product[26:0];

                    // Simplified rounding logic
                    if (guard_bit || round_bit || sticky) begin
                        z[22:0] <= product[47:25] + 1;
                    end else begin
                        z[22:0] <= product[47:25];
                    end
                    z[30:23] <= a_exponent + b_exponent - 8'h7f;
                    z[31] <= a_sign ^ b_sign;
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    // Output formatting stage
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
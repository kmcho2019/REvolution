module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    // Internal signals
    reg [22:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [49:0] product;
    reg [2:0] state;
    reg guard_bit, round_bit, sticky;

    // Extract inputs
    assign a_mantissa = a[22:0];
    assign a_exponent = a[30:23];
    assign a_sign = a[31];
    assign b_mantissa = b[22:0];
    assign b_exponent = b[30:23];
    assign b_sign = b[31];

    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
            z <= 0;
        end else begin
            case (state)
                3'd0: begin
                    // Check for special cases
                    if ((a_exponent == 8'hff && a_mantissa!= 0) || (b_exponent == 8'hff && b_mantissa!= 0)) begin
                        z <= 32'h7fc00000; // NaN
                    end else if ((a_exponent == 8'hff && a_mantissa == 0) || (b_exponent == 8'hff && b_mantissa == 0)) begin
                        if (a_sign == b_sign) begin
                            z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                        end else begin
                            z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                        end
                    end else begin
                        state <= state + 1;
                    end
                end
                3'd1: begin
                    // Multiply mantissas
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    guard_bit <= product[24];
                    round_bit <= product[25];
                    sticky <= |product[26:0];

                    // Normalize and round
                    if (guard_bit && (round_bit || sticky)) begin
                        z[22:0] <= product[47:25] + 1;
                    end else begin
                        z[22:0] <= product[47:25];
                    end

                    // Calculate exponent
                    z[30:23] <= a_exponent + b_exponent - 8'h7f;

                    // Determine sign
                    z[31] <= a_sign ^ b_sign;

                    state <= 0; // Back to IDLE
                end
            endcase
        end
    end
endmodule
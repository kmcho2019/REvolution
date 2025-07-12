module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    // Internal signals
    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    // FSM states
    parameter IDLE = 3'b000;
    parameter INPUT_PROCESS = 3'b001;
    parameter SPECIAL_CASES = 3'b010;
    parameter NORMALIZATION = 3'b011;
    parameter MULTIPLICATION = 3'b100;
    parameter ROUNDING = 3'b101;
    parameter OUTPUT_GENERATION = 3'b110;

    // Reset logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            z_mantissa <= 24'd0;
            a_exponent <= 9'd0;
            b_exponent <= 9'd0;
            z_exponent <= 9'd0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;
            product <= 50'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;
        end
        else begin
            case (counter)
                // Initialize and extract inputs
                IDLE: begin
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];
                    counter <= INPUT_PROCESS;
                end

                // Handle special cases (NaN, infinity)
                INPUT_PROCESS: begin
                    if ((a_exponent == 9'd255 && a_mantissa != 24'd0) || (b_exponent == 9'd255 && b_mantissa != 24'd0)) begin
                        // NaN or infinity, set output accordingly
                        z <= 32'd0; // Default to zero for simplicity, actual handling may vary
                    end
                    else begin
                        counter <= SPECIAL_CASES;
                    end
                end

                // Check for special cases and handle them
                SPECIAL_CASES: begin
                    if ((a_exponent == 9'd0 && a_mantissa == 24'd0) || (b_exponent == 9'd0 && b_mantissa == 24'd0)) begin
                        // Zero, set output to zero
                        z <= 32'd0;
                    end
                    else if (a_exponent == 9'd255 && a_mantissa == 24'd0) begin
                        // a is infinity
                        if (b_exponent == 9'd255 && b_mantissa == 24'd0) begin
                            // b is infinity, set output to infinity with correct sign
                            z <= {a_sign || b_sign, 9'd255, 23'd0};
                        end
                        else begin
                            // b is not infinity, set output to infinity with correct sign
                            z <= {a_sign || b_sign, 9'd255, 23'd0};
                        end
                    end
                    else if (b_exponent == 9'd255 && b_mantissa == 24'd0) begin
                        // b is infinity
                        z <= {a_sign || b_sign, 9'd255, 23'd0};
                    end
                    else begin
                        counter <= NORMALIZATION;
                    end
                end

                // Normalize mantissas if necessary
                NORMALIZATION: begin
                    // Simplified normalization for demonstration purposes
                    if (a_mantissa[23]) begin
                        a_mantissa <= a_mantissa << 1;
                        a_exponent <= a_exponent - 1;
                    end
                    if (b_mantissa[23]) begin
                        b_mantissa <= b_mantissa << 1;
                        b_exponent <= b_exponent - 1;
                    end
                    counter <= MULTIPLICATION;
                end

                // Multiply mantissas and combine signs
                MULTIPLICATION: begin
                    product <= a_mantissa * b_mantissa;
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= a_exponent + b_exponent - 127; // Bias adjustment
                    counter <= ROUNDING;
                end

                // Round result and adjust exponent
                ROUNDING: begin
                    // Simplified rounding logic for demonstration purposes
                    guard_bit <= product[1];
                    round_bit <= product[2];
                    sticky <= |product[0];
                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= product[49:26] + 1;
                    end
                    else begin
                        z_mantissa <= product[49:26];
                    end
                    if (z_mantissa[23]) begin
                        z_mantissa <= z_mantissa >> 1;
                        z_exponent <= z_exponent + 1;
                    end
                    counter <= OUTPUT_GENERATION;
                end

                // Format output in IEEE 754 standard
                OUTPUT_GENERATION: begin
                    z <= {z_sign, z_exponent, z_mantissa[22:0]};
                    counter <= IDLE;
                end

                default: counter <= IDLE;
            endcase
        end
    end
endmodule
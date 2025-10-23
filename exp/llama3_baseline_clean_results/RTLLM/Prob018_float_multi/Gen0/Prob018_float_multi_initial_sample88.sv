module float_multi(clk, rst, a, b, z);
    input clk;
    input rst;
    input [31:0] a;
    input [31:0] b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    // Internal wires for intermediate calculations
    wire [49:0] mantissa_product;
    wire [8:0] exponent_sum;

    // Extract mantissas, exponents, and signs from inputs
    assign a_mantissa = a[22:0];
    assign b_mantissa = b[22:0];
    assign a_exponent = a[30:23];
    assign b_exponent = b[30:23];
    assign a_sign = a[31];
    assign b_sign = b[31];

    // Special cases handling (simplified for demonstration)
    always @(*) begin
        if (a_exponent == 9'b111111111 || b_exponent == 9'b111111111) begin
            // Handle infinity
            z_sign = a_sign || b_sign;
            z_exponent = 9'b111111111;
            z_mantissa = 24'b0;
        end else if (a_exponent == 9'b0 && b_exponent == 9'b0) begin
            // Handle zero
            z_sign = a_sign || b_sign;
            z_exponent = 9'b0;
            z_mantissa = 24'b0;
        end else begin
            // Normal operation
            // Multiply mantissas
            mantissa_product = {1'b1, a_mantissa} * {1'b1, b_mantissa};
            // Calculate new exponent
            exponent_sum = a_exponent + b_exponent - 127;
            // Round and adjust
            guard_bit = mantissa_product[48];
            round_bit = mantissa_product[47];
            sticky = |mantissa_product[46:0];
            if (guard_bit && (round_bit || sticky)) begin
                z_mantissa = mantissa_product[47:24] + 1'b1;
                if (z_mantissa == 24'b1_000000_000000_000000_000000) begin
                    z_exponent = exponent_sum + 1'b1;
                    z_mantissa = 24'b0;
                end else begin
                    z_exponent = exponent_sum;
                end
            end else begin
                z_mantissa = mantissa_product[47:24];
                z_exponent = exponent_sum;
            end
            z_sign = a_sign ^ b_sign;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
        end else begin
            case (counter)
                3'b000: begin
                    // Initialize for the next operation
                    counter <= counter + 1'b1;
                end
                3'b001: begin
                    // Input processing and special cases handling
                    // Already handled in the combinational logic
                    counter <= counter + 1'b1;
                end
                3'b010: begin
                    // Multiplication and rounding
                    // Already handled in the combinational logic
                    counter <= counter + 1'b1;
                end
                3'b011: begin
                    // Output generation
                    if (z_exponent > 9'b111111110) begin
                        // Overflow
                        z <= {z_sign, 9'b111111111, 23'b0};
                    end else if (z_exponent < 9'b1) begin
                        // Underflow
                        z <= {z_sign, 9'b0, 23'b0};
                    end else begin
                        z <= {z_sign, z_exponent, z_mantissa};
                    end
                    counter <= 3'b000;
                end
                default: counter <= 3'b000;
            endcase
        end
    end
endmodule
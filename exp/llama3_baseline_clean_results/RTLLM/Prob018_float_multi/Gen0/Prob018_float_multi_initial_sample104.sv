module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1'b1;
            end
            3'b001: begin
                // Special cases handling
                if ((a_exponent == 10'b11111111) && (a_mantissa!= 23'b0)) begin
                    // NaN
                    z <= 32'b1; // Set NaN flag
                    counter <= 3'b000;
                end else if ((b_exponent == 10'b11111111) && (b_mantissa!= 23'b0)) begin
                    // NaN
                    z <= 32'b1; // Set NaN flag
                    counter <= 3'b000;
                end else if ((a_exponent == 10'b11111111) && (a_mantissa == 23'b0)) begin
                    // Infinity
                    if (b_exponent == 10'b11111111) begin
                        // Infinity * Infinity = Infinity
                        z <= {a_sign, 8'b0, 23'b0};
                        counter <= 3'b000;
                    end else begin
                        counter <= counter + 1'b1;
                    end
                end else if ((b_exponent == 10'b11111111) && (b_mantissa == 23'b0)) begin
                    // Infinity
                    if (a_exponent == 10'b11111111) begin
                        // Infinity * Infinity = Infinity
                        z <= {b_sign, 8'b0, 23'b0};
                        counter <= 3'b000;
                    end else begin
                        counter <= counter + 1'b1;
                    end
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            3'b010: begin
                // Normalization
                if (a_mantissa[23] == 1'b0) begin
                    // Normalize a
                    a_mantissa <= {1'b1, a_mantissa[22:0]};
                    a_exponent <= a_exponent - 10'b1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    // Normalize b
                    b_mantissa <= {1'b1, b_mantissa[22:0]};
                    b_exponent <= b_exponent - 10'b1;
                end
                counter <= counter + 1'b1;
            end
            3'b011: begin
                // Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 10'b127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1'b1;
            end
            3'b100: begin
                // Rounding and adjustment
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= product[47:0]!= 50'b0;
                if (guard_bit || round_bit || sticky) begin
                    // Round up
                    z_mantissa <= product[48:25] + 1'b1;
                end else begin
                    // Round down
                    z_mantissa <= product[48:25];
                end
                if (z_mantissa[23] == 1'b1) begin
                    // Overflow
                    z_exponent <= z_exponent + 10'b1;
                    z_mantissa <= z_mantissa >> 1'b1;
                end
                counter <= counter + 1'b1;
            end
            3'b101: begin
                // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule
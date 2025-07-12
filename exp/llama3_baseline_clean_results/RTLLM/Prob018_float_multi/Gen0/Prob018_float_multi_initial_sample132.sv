module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// FSM state transitions
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Reset and extract input components
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                counter <= 3'b001;
            end
            3'b001: begin // Handle special cases (NaN, Infinity) and normalize mantissas
                if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
                    // Handle special cases
                    if ((a_exponent == 9'b111111111) && (a_mantissa!= 0)) begin
                        z <= {1'b1, {8{1'b1}}, {23{1'b0}}}; // NaN
                    end else if ((b_exponent == 9'b111111111) && (b_mantissa!= 0)) begin
                        z <= {1'b1, {8{1'b1}}, {23{1'b0}}}; // NaN
                    end else if ((a_exponent == 9'b111111111) && (a_mantissa == 0) && (b_exponent == 9'b111111111) && (b_mantissa == 0)) begin
                        z <= {1'b1, {8{1'b1}}, {23{1'b0}}}; // Infinity * Infinity
                    end else if ((a_exponent == 9'b111111111) && (a_mantissa == 0)) begin
                        z <= {1'b1, {8{1'b1}}, {23{1'b0}}}; // Infinity
                    end else if ((b_exponent == 9'b111111111) && (b_mantissa == 0)) begin
                        z <= {1'b1, {8{1'b1}}, {23{1'b0}}}; // Infinity
                    end
                    counter <= 3'b111;
                end else begin
                    // Normalize mantissas
                    if (a_mantissa[23] == 1'b0) begin
                        a_mantissa <= {a_mantissa[22:0], 1'b0};
                        a_exponent <= a_exponent - 1'b1;
                    end
                    if (b_mantissa[23] == 1'b0) begin
                        b_mantissa <= {b_mantissa[22:0], 1'b0};
                        b_exponent <= b_exponent - 1'b1;
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin // Multiply mantissas and combine signs
                product <= (a_mantissa * b_mantissa);
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b011;
            end
            3'b011: begin // Adjust exponent and round result
                z_exponent <= a_exponent + b_exponent - 127;
                // Rounding logic (simplified for demonstration purposes)
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                if ((guard_bit && round_bit) || sticky) begin
                    z_mantissa <= product[47:24] + 1'b1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                counter <= 3'b100;
            end
            3'b100: begin // Format output
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b111;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule
module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// State machine to control the operation sequence
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Reset and input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b001;
            end
            3'b001: begin // Special cases handling
                if ((a_exponent == 8'b11111111) && (a_mantissa!= 24'b0)) begin // a is NaN
                    z <= {32{1'b1}}; // NaN
                    counter <= 3'b000;
                end else if ((b_exponent == 8'b11111111) && (b_mantissa!= 24'b0)) begin // b is NaN
                    z <= {32{1'b1}}; // NaN
                    counter <= 3'b000;
                end else if ((a_exponent == 8'b11111111) && (a_mantissa == 24'b0) && (b_exponent == 8'b11111111) && (b_mantissa == 24'b0)) begin // Both are infinity
                    z <= {1'b0, 8'b11111111, 23'b0}; // Infinity
                    counter <= 3'b000;
                end else begin
                    counter <= 3'b010;
                end
            end
            3'b010: begin // Multiplication
                product <= (a_mantissa + 1) * (b_mantissa + 1);
                z_exponent <= a_exponent + b_exponent - 127;
                counter <= 3'b011;
            end
            3'b011: begin // Rounding and adjustment
                // Perform rounding and adjust the exponent if necessary
                guard_bit <= product[47];
                round_bit <= product[46];
                sticky <= |product[45:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[45:22] + 1;
                end else begin
                    z_mantissa <= product[45:22];
                end
                counter <= 3'b100;
            end
            3'b100: begin // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule
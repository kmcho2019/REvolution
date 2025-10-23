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

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        z_mantissa <= 24'b0;
        a_exponent <= 8'b0;
        b_exponent <= 8'b0;
        z_exponent <= 8'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin // Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1'b1;
            end
            3'b001: begin // Special Cases Handling
                if ((a_exponent == 8'b255) || (b_exponent == 8'b255)) begin // NaN or Infinity
                    if ((a_exponent == 8'b255) && (a_mantissa!= 24'b0)) begin // NaN
                        z_exponent <= 8'b255;
                        z_mantissa <= 24'b0;
                        z_sign <= a_sign;
                    end else if ((b_exponent == 8'b255) && (b_mantissa!= 24'b0)) begin // NaN
                        z_exponent <= 8'b255;
                        z_mantissa <= 24'b0;
                        z_sign <= b_sign;
                    end else begin // Infinity
                        if (a_exponent == 8'b255) begin
                            z_exponent <= 8'b255;
                            z_mantissa <= 24'b0;
                            z_sign <= a_sign;
                        end else begin
                            z_exponent <= 8'b255;
                            z_mantissa <= 24'b0;
                            z_sign <= b_sign;
                        end
                    end
                    counter <= 3'b111; // Output Generation
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            3'b010: begin // Normalization
                if (a_exponent!= 8'b0) begin
                    a_mantissa <= {1'b1, a_mantissa}; // Normalize a
                end
                if (b_exponent!= 8'b0) begin
                    b_mantissa <= {1'b1, b_mantissa}; // Normalize b
                end
                counter <= counter + 1'b1;
            end
            3'b011: begin // Multiplication
                product <= {a_mantissa, 24'b0} * {b_mantissa, 24'b0};
                z_exponent <= a_exponent + b_exponent - 8'b127; // Adjust exponent
                z_sign <= a_sign ^ b_sign; // Combine signs
                counter <= counter + 1'b1;
            end
            3'b100: begin // Rounding and Adjustment
                guard_bit <= product[0];
                round_bit <= product[1];
                sticky <= |product[2:0];
                if ((guard_bit == 1'b1) && ((round_bit == 1'b1) || (sticky == 1'b1))) begin
                    z_mantissa <= product[49:26] + 1'b1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                counter <= counter + 1'b1;
            end
            3'b101: begin // Output Generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000; // Reset counter
            end
            default: begin
                counter <= counter;
            end
        endcase
    end
end

endmodule
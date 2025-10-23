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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        a_exponent <= 8'b0;
        b_exponent <= 8'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
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
                counter <= counter + 1;
            end
            3'b001: begin
                // Special cases handling
                if ((a_exponent == 8'b255) && (a_mantissa != 24'b0)) begin
                    // a is NaN
                    z <= 32'b1; // NaN
                end else if ((b_exponent == 8'b255) && (b_mantissa != 24'b0)) begin
                    // b is NaN
                    z <= 32'b1; // NaN
                end else if ((a_exponent == 8'b255) && (a_mantissa == 24'b0) && (b_exponent == 8'b255) && (b_mantissa == 24'b0)) begin
                    // both a and b are infinity
                    if (a_sign == b_sign) begin
                        z <= {1'b0, 8'b255, 23'b0}; // infinity
                    end else begin
                        z <= 32'b0; // zero
                    end
                end else if ((a_exponent == 8'b255) && (a_mantissa == 24'b0)) begin
                    // a is infinity
                    z <= {1'b0, 8'b255, 23'b0}; // infinity
                end else if ((b_exponent == 8'b255) && (b_mantissa == 24'b0)) begin
                    // b is infinity
                    z <= {1'b0, 8'b255, 23'b0}; // infinity
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b010: begin
                // Normalization
                if (a_mantissa[23] == 1'b0) begin
                    // a is denormalized
                    a_mantissa <= {1'b1, a_mantissa[22:0]};
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    // b is denormalized
                    b_mantissa <= {1'b1, b_mantissa[22:0]};
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            3'b011: begin
                // Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'b100: begin
                // Rounding and adjustment
                if (product[48] == 1'b1) begin
                    // round up
                    z_mantissa <= product[47:24] + 1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                if (z_mantissa[23] == 1'b1) begin
                    // overflow
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= {1'b0, z_mantissa[22:0]};
                end
                counter <= counter + 1;
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
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

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z_mantissa <= 24'b0;
        z_exponent <= 9'b0;
        z_sign <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1'b1;
            end
            3'b001: begin
                // Special Cases Handling
                if ((a_exponent == 9'b255 && a_mantissa!= 24'b0) || (b_exponent == 9'b255 && b_mantissa!= 24'b0)) begin
                    // NaN
                    z <= 32'b1;
                end else if ((a_exponent == 9'b255 && a_mantissa == 24'b0) || (b_exponent == 9'b255 && b_mantissa == 24'b0)) begin
                    // Infinity
                    z <= 32'b0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            3'b010: begin
                // Normalization
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent - 1'b1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent - 1'b1;
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
                // Rounding and Adjustment
                guard_bit <= product[0];
                round_bit <= product[1];
                sticky <= |product[48:2];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:24] + 1'b1;
                end else begin
                    z_mantissa <= product[49:24];
                end
                if (z_mantissa[23] == 1'b1) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1'b1;
                end
                counter <= counter + 1'b1;
            end
            3'b101: begin
                // Output Generation
                if (z_exponent > 9'b127) begin
                    // Overflow
                    z <= 32'b1;
                end else if (z_exponent < 9'b1) begin
                    // Underflow
                    z <= 32'b0;
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule
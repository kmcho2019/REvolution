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

always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case(counter)
            3'b000: begin
                // Input processing
                a_sign <= a[31];
                b_sign <= b[31];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                counter <= 3'b001;
            end
            3'b001: begin
                // Special cases handling
                if(a_exponent == 9'b11111111 && a_mantissa!= 24'b0) begin
                    // NaN
                    z <= 32'h7fc00000;
                end else if(b_exponent == 9'b11111111 && b_mantissa!= 24'b0) begin
                    // NaN
                    z <= 32'h7fc00000;
                end else if(a_exponent == 9'b11111111 && a_mantissa == 24'b0) begin
                    // Infinity
                    if(a_sign)
                        z <= 32'hff800000;
                    else
                        z <= 32'h78000000;
                end else if(b_exponent == 9'b11111111 && b_mantissa == 24'b0) begin
                    // Infinity
                    if(b_sign)
                        z <= 32'hff800000;
                    else
                        z <= 32'h78000000;
                end else begin
                    // Normalization
                    if(a_exponent == 9'b0) begin
                        a_mantissa <= {1'b1, a_mantissa};
                        a_exponent <= 9'b1;
                    end
                    if(b_exponent == 9'b0) begin
                        b_mantissa <= {1'b1, b_mantissa};
                        b_exponent <= 9'b1;
                    end
                    counter <= 3'b010;
                end
            end
            3'b010: begin
                // Multiplication
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 9'b127;
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                counter <= 3'b011;
            end
            3'b011: begin
                // Rounding and adjustment
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[3:0];
                if(guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1'b1;
                    if(z_mantissa[23]) begin
                        z_exponent <= z_exponent + 1'b1;
                        z_mantissa <= z_mantissa[22:0];
                    end
                end else begin
                    z_mantissa <= product[49:26];
                end
                counter <= 3'b100;
            end
            3'b100: begin
                // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule
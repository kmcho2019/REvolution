module float_multi(clk, rst, a, b, z);

input clk, rst;
input [31:0] a, b;
output reg [31:0] z;

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                
                // Check for special cases
                if ((a_exponent == 10'b1111111111) && (a_mantissa != 23'b0)) begin
                    // a is NaN
                    z <= 32'b0;
                    counter <= 3'b111;
                end else if ((b_exponent == 10'b1111111111) && (b_mantissa != 23'b0)) begin
                    // b is NaN
                    z <= 32'b0;
                    counter <= 3'b111;
                end else if ((a_exponent == 10'b1111111111) && (a_mantissa == 23'b0) && (b_exponent == 10'b1111111111) && (b_mantissa == 23'b0)) begin
                    // Both a and b are infinity
                    z <= {1'b0, 10'b1111111111, 23'b0};
                    counter <= 3'b111;
                end else begin
                    counter <= 3'b001;
                end
            end
            
            3'b001: begin
                // Normalize mantissas
                if (a_exponent == 10'b0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= 10'b1;
                end
                
                if (b_exponent == 10'b0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= 10'b1;
                end
                
                // Multiply mantissas and combine signs
                product <= (a_mantissa * b_mantissa);
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 10'b127;
                
                counter <= 3'b010;
            end
            
            3'b010: begin
                // Rounding and adjustment
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                
                if (guard_bit && (round_bit || sticky)) begin
                    product[48:24] <= product[48:24] + 1;
                end
                
                z_mantissa <= product[47:24];
                z_exponent <= z_exponent + 10'b1;
                
                counter <= 3'b011;
            end
            
            3'b011: begin
                // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b111;
            end
            
            default: counter <= 3'b111;
        endcase
    end
end

endmodule
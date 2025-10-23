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
        z <= 32'd0;
    end else begin
        case (counter)
            3'b000: begin // Input processing
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= {1'b1, a[22:0]}; // implicit 1
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= {1'b1, b[22:0]}; // implicit 1
                counter <= 3'b001;
            end
            3'b001: begin // Special cases handling
                if ((a_exponent == 9'd255 && a_mantissa!= 24'd0) || (b_exponent == 9'd255 && b_mantissa!= 24'd0)) begin
                    // NaN or infinity
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 9'd255;
                    z_mantissa <= 24'd0;
                    z <= {z_sign, z_exponent, z_mantissa};
                    counter <= 3'b000;
                end else if (a_exponent == 9'd0 || b_exponent == 9'd0) begin
                    // Denormalized numbers
                    // normalization and multiplication
                    counter <= 3'b010;
                end else begin
                    // Normalized numbers
                    counter <= 3'b010;
                end
            end
            3'b010: begin // Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 9'd127; // adjust exponent
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b011;
            end
            3'b011: begin // Rounding and adjustment
                // extract guard, round, and sticky bits
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[3:0];
                if (guard_bit && (round_bit || sticky)) begin
                    // round up
                    z_mantissa <= product[49:26] + 1;
                    if (z_mantissa[23]) begin
                        // overflow, adjust exponent
                        z_exponent <= z_exponent + 1;
                        z_mantissa <= z_mantissa[22:0];
                    end
                end else begin
                    z_mantissa <= product[49:26];
                end
                counter <= 3'b100;
            end
            3'b100: begin // Output generation
                z <= {z_sign, z_exponent, z_mantissa[22:0]};
                counter <= 3'b000;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule
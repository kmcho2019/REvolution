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

// Reset logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'd0;
        b_mantissa <= 24'd0;
        z_mantissa <= 24'd0;
        a_exponent <= 10'd0;
        b_exponent <= 10'd0;
        z_exponent <= 10'd0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'd0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        // Input Processing
        if (counter == 3'b000) begin
            a_sign <= a[31];
            a_exponent <= a[30:23];
            a_mantissa <= a[22:0];
            b_sign <= b[31];
            b_exponent <= b[30:23];
            b_mantissa <= b[22:0];
            counter <= counter + 1'b1;
        end

        // Special Cases Handling
        else if (counter == 3'b001) begin
            if ((a_exponent == 10'd255 && a_mantissa!= 24'd0) || (b_exponent == 10'd255 && b_mantissa!= 24'd0)) begin
                // NaN case
                z_sign <= a_sign ^ b_sign;
                z_exponent <= 10'd255;
                z_mantissa <= 24'd0;
            end else if ((a_exponent == 10'd255 && a_mantissa == 24'd0) || (b_exponent == 10'd255 && b_mantissa == 24'd0)) begin
                // Infinity case
                z_sign <= a_sign ^ b_sign;
                z_exponent <= 10'd255;
                z_mantissa <= 24'd0;
            end else begin
                counter <= counter + 1'b1;
            end
        end

        // Normalization
        else if (counter == 3'b010) begin
            if (a_mantissa[23] == 1'b0) begin
                a_mantissa <= {1'b0, a_mantissa[23:1]};
                a_exponent <= a_exponent - 10'd1;
            end
            if (b_mantissa[23] == 1'b0) begin
                b_mantissa <= {1'b0, b_mantissa[23:1]};
                b_exponent <= b_exponent - 10'd1;
            end
            counter <= counter + 1'b1;
        end

        // Multiplication
        else if (counter == 3'b011) begin
            product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
            z_exponent <= a_exponent + b_exponent - 10'd127;
            z_sign <= a_sign ^ b_sign;
            counter <= counter + 1'b1;
        end

        // Rounding and Adjustment
        else if (counter == 3'b100) begin
            if (product[49:48] == 2'b11) begin
                z_mantissa <= product[47:24] + 24'd1;
            end else if (product[49:48] == 2'b10) begin
                z_mantissa <= product[47:24];
            end else begin
                z_mantissa <= product[47:24];
            end
            counter <= counter + 1'b1;
        end

        // Output Generation
        else if (counter == 3'b101) begin
            z <= {z_sign, z_exponent, z_mantissa};
            counter <= 3'b000;
        end
    end
end

endmodule
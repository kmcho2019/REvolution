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
        z <= 32'h00000000;
    end else begin
        case (counter)
            3'b000: begin // Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                if ((a_exponent == 9'hff && a_mantissa != 0) || (b_exponent == 9'hff && b_mantissa != 0)) begin
                    z_sign <= 1'b1;
                    z_exponent <= 9'hff;
                    z_mantissa <= 24'h000000;
                    counter <= 3'b100; // Output Generation
                end else if (a_exponent == 9'hff || b_exponent == 9'hff) begin
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 9'hff;
                    z_mantissa <= 24'h000000;
                    counter <= 3'b100; // Output Generation
                end else begin
                    counter <= 3'b001; // Special Cases Handling
                end
            end
            3'b001: begin // Special Cases Handling
                if (a_exponent == 0 && b_exponent == 0) begin
                    z_exponent <= 0;
                    z_mantissa <= a_mantissa * b_mantissa;
                    counter <= 3'b010; // Normalization
                end else if (a_exponent == 0) begin
                    z_exponent <= b_exponent - 1;
                    z_mantissa <= a_mantissa * (1 << (b_exponent - 1));
                    counter <= 3'b010; // Normalization
                end else if (b_exponent == 0) begin
                    z_exponent <= a_exponent - 1;
                    z_mantissa <= (1 << (a_exponent - 1)) * b_mantissa;
                    counter <= 3'b010; // Normalization
                end else begin
                    z_exponent <= a_exponent + b_exponent - 127;
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    counter <= 3'b011; // Multiplication
                end
            end
            3'b010: begin // Normalization
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= 3'b011; // Multiplication
            end
            3'b011: begin // Multiplication
                if (product[49]) begin
                    z_exponent <= z_exponent + 1;
                    product <= product >> 1;
                end
                z_mantissa <= product[23:0];
                counter <= 3'b100; // Output Generation
            end
            3'b100: begin // Output Generation
                z_sign <= a_sign ^ b_sign;
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule
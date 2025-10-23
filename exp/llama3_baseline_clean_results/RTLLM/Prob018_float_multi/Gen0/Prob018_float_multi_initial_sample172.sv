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
    if(rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case(counter)
            3'b000: begin // Input processing and special cases handling
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                // Special cases: NaN, Infinity
                if ((a_exponent == 8'b11111111 && a_mantissa!= 24'b0) || 
                    (b_exponent == 8'b11111111 && b_mantissa!= 24'b0)) begin
                    z <= 32'b1; // Simplified handling, actual implementation requires more complex logic
                end else if (a_exponent == 8'b11111111 || b_exponent == 8'b11111111) begin
                    z <= 32'b1; // Infinity handling
                end
                counter <= counter + 1;
            end
            3'b001: begin // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 8'd127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'b010: begin // Rounding and adjustment
                {guard_bit, round_bit, sticky} <= product[49:47];
                if (guard_bit || round_bit || sticky) begin
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    z_mantissa <= product[46:23];
                end
                // Adjust exponent if overflow
                if (product[47]) begin
                    z_exponent <= z_exponent + 1;
                end
                counter <= counter + 1;
            end
            3'b011: begin // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
            default: counter <= counter;
        endcase
    end
end

endmodule
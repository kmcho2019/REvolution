module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas

// Extract inputs using combinational logic
assign a_sign = a[31];
assign a_exponent = a[30:23];
assign a_mantissa = a[22:0];
assign b_sign = b[31];
assign b_exponent = b[30:23];
assign b_mantissa = b[22:0];

// State machine logic with combinational extraction
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000; // Reset counter
        z <= 32'b0; // Reset output
    end else begin
        case(counter)
            3'b000: begin
                // Check for special cases
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    // Handle NaN and infinity
                    if ((a_exponent == 9'b11111111) && (a_mantissa!= 23'b0)) begin
                        z <= 32'b1; // NaN
                    end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 23'b0)) begin
                        z <= 32'b1; // NaN
                    end else if (a_exponent == 9'b11111111) begin
                        z <= (a_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
                    end else begin
                        z <= (b_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
                    end
                    counter <= 3'b000;
                end else begin
                    // Calculate product and exponent
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= a_exponent + b_exponent - 9'b10000000;
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    counter <= 3'b001;
                end
            end
            3'b001: begin
                // Normalize and round result
                z_mantissa <= product[48:25];
                if (product[24]) begin
                    z_mantissa <= z_mantissa + 1;
                end
                if (z_mantissa == 24'b100000000000000000000000) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= 23'b0;
                end
                counter <= 3'b010;
            end
            3'b010: begin
                // Output result
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000; // Reset counter
            end
            default: counter <= 3'b000;
        endcase
    end
end

endmodule
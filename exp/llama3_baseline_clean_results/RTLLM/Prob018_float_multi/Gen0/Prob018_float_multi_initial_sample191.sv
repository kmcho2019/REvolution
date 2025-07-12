module float_multi(
    input               clk,
    input               rst,
    input      [31:0]    a,
    input      [31:0]    b,
    output reg [31:0]    z
);

// Internal signals
reg     [2:0]    counter;
reg     [23:0]   a_mantissa, b_mantissa, z_mantissa;
reg     [7:0]    a_exponent, b_exponent, z_exponent;
reg               a_sign, b_sign, z_sign;
reg     [49:0]   product;
reg               guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 3'b000;
    end else begin
        case(counter)
            3'b000: begin
                // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1'b1;
            end
            3'b001: begin
                // Special cases handling
                if(a_exponent == 8'hff && a_mantissa != 23'b0) begin
                    // NaN
                    z <= {a_sign, 8'hff, 23'b0};
                    counter <= 3'b000;
                end else if(b_exponent == 8'hff && b_mantissa != 23'b0) begin
                    // NaN
                    z <= {b_sign, 8'hff, 23'b0};
                    counter <= 3'b000;
                end else if(a_exponent == 8'hff && a_mantissa == 23'b0 && b_exponent == 8'hff && b_mantissa == 23'b0) begin
                    // Infinity * Infinity
                    z <= {a_sign ^ b_sign, 8'hff, 23'b0};
                    counter <= 3'b000;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            3'b010: begin
                // Normalization
                if(a_exponent != 8'h00) begin
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= a_exponent - 1'b1;
                end
                if(b_exponent != 8'h00) begin
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= b_exponent - 1'b1;
                end
                counter <= counter + 1'b1;
            end
            3'b011: begin
                // Multiplication
                product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 8'h7f;
                counter <= counter + 1'b1;
            end
            3'b100: begin
                // Rounding and adjustment
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if(guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[46:24] + 1'b1;
                end else begin
                    z_mantissa <= product[46:24];
                end
                if(z_mantissa[23]) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1'b1;
                end
                counter <= counter + 1'b1;
            end
            3'b101: begin
                // Output generation
                if(z_exponent > 8'hff) begin
                    // Overflow
                    z <= {z_sign, 8'hff, 23'b0};
                end else if(z_exponent < 1'b0) begin
                    // Underflow
                    z <= {z_sign, 8'h00, 23'b0};
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule
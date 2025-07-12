module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'd0;
        z_mantissa <= 24'd0;
        z_exponent <= 8'd0;
        z_sign <= 1'd0;
        z <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin
                // Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1'd1;
            end
            3'd1: begin
                // Special Cases Handling
                if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
                    // Handle NaN or infinity
                    if (a_exponent == 8'd255 && a_mantissa != 24'd0) begin
                        z <= 32'h7fc00000; // NaN
                    end else if (b_exponent == 8'd255 && b_mantissa != 24'd0) begin
                        z <= 32'h7fc00000; // NaN
                    end else if (a_exponent == 8'd255 && a_mantissa == 24'd0) begin
                        z <= (a_sign == 1'd0) ? 32'h7f800000 : 32'hff800000; // infinity
                    end else if (b_exponent == 8'd255 && b_mantissa == 24'd0) begin
                        z <= (a_sign == 1'd0 && b_sign == 1'd0) || (a_sign == 1'd1 && b_sign == 1'd1) ? 32'h7f800000 : 32'hff800000; // infinity
                    end
                    counter <= 3'd4; // Output Generation
                end else begin
                    // Normalization
                    if (a_exponent != 8'd0) begin
                        a_mantissa <= {1'd1, a_mantissa};
                    end
                    if (b_exponent != 8'd0) begin
                        b_mantissa <= {1'd1, b_mantissa};
                    end
                    counter <= counter + 1'd1;
                end
            end
            3'd2: begin
                // Multiplication
                product <= a_mantissa * b_mantissa;
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 8'd127;
                counter <= counter + 1'd1;
            end
            3'd3: begin
                // Rounding and Adjustment
                guard_bit <= product[23];
                round_bit <= product[24];
                sticky <= |product[25:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[23:0] + 24'd1;
                end else begin
                    z_mantissa <= product[23:0];
                end
                if (z_mantissa[23] == 1'd1) begin
                    z_mantissa <= {1'd0, z_mantissa[22:0]};
                    z_exponent <= z_exponent + 8'd1;
                end
                counter <= counter + 1'd1;
            end
            3'd4: begin
                // Output Generation
                if (z_exponent > 8'd255) begin
                    z <= (z_sign == 1'd0) ? 32'h7f800000 : 32'hff800000; // infinity
                end else if (z_exponent < 8'd1) begin
                    z <= (z_sign == 1'd0) ? 32'h3f800000 : 32'hbf800000; // zero
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa[22:0]};
                end
                counter <= 3'd0;
            end
        endcase
    end
end

endmodule
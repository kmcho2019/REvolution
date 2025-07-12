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

always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 0;
        z <= 0;
    end else begin
        case(counter)
            0: begin // Input Processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                // Special Cases Handling
                if((a_exponent == 8'hFF && a_mantissa != 0) || (b_exponent == 8'hFF && b_mantissa != 0)) begin
                    // NaN or Infinity, set result accordingly
                    z <= (a_exponent == 8'hFF && a_mantissa != 0) ? a : b;
                end else if(a_exponent == 8'h00 || b_exponent == 8'h00) begin
                    // Zero, set result to zero
                    z <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            1: begin // Normalization and Multiplication
                if(a_exponent == 8'hFF) begin
                    z_exponent <= a_exponent + b_exponent - 127;
                    z_mantissa <= a_mantissa + b_mantissa;
                    z_sign <= a_sign ^ b_sign;
                    counter <= counter + 1;
                end else begin
                    // Normalize mantissas if needed
                    if(a_mantissa[22] == 0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:1]};
                        a_exponent <= a_exponent - 1;
                    end
                    if(b_mantissa[22] == 0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:1]};
                        b_exponent <= b_exponent - 1;
                    end
                    // Perform multiplication
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    counter <= counter + 1;
                end
            end
            2: begin // Rounding and Adjustment
                z_mantissa <= product[48:25];
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                // Rounding control bits
                guard_bit <= product[24];
                round_bit <= product[23];
                sticky <= |product[22:0];
                // Apply rounding
                if(guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                end
                counter <= counter + 1;
            end
            3: begin // Output Generation
                // Check for overflow and underflow
                if(z_exponent > 255) begin
                    // Overflow, set result to infinity
                    z <= {z_sign, 8'hFF, 23'h000000};
                end else if(z_exponent < 1) begin
                    // Underflow, set result to zero or denormalized number
                    if(z_mantissa[22] == 1) begin
                        z <= {z_sign, 8'h00, z_mantissa};
                    end else begin
                        z <= 0;
                    end
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 0;
            end
        endcase
    end
end

endmodule
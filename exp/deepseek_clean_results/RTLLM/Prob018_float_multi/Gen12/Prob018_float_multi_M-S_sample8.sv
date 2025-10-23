module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg state;
    reg [22:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    wire [47:0] product;
    wire is_nan, is_inf, is_zero;

    // Special case detection
    assign is_nan = ((&a[30:23] && |a[22:0]) || ((&b[30:23] && |b[22:0]));
    assign is_inf = ((&a[30:23] && ~|a[22:0]) || (&b[30:23] && ~|b[22:0])) && !is_nan;
    assign is_zero = (~|a[30:0] || ~|b[30:0]);

    // Mantissa multiplication
    assign product = {1'b1, a_mantissa} * {1'b1, b_mantissa};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin  // Input processing
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    state <= 1;
                end

                1: begin  // Computation and output
                    if (is_nan) begin
                        z <= 32'h7FC00000;
                    end else if (is_inf) begin
                        z <= {a_sign ^ b_sign, 8'hFF, 23'b0};
                    end else if (is_zero) begin
                        z <= {a_sign ^ b_sign, 31'b0};
                    end else begin
                        // Normalize and round (truncate)
                        if (product[47]) begin
                            z <= {a_sign ^ b_sign, 
                                 a_exponent + b_exponent - 126, 
                                 product[46:24]};
                        end else begin
                            z <= {a_sign ^ b_sign,
                                 a_exponent + b_exponent - 127,
                                 product[45:23]};
                        end
                    end
                    state <= 0;
                end
            endcase
        end
    end

endmodule
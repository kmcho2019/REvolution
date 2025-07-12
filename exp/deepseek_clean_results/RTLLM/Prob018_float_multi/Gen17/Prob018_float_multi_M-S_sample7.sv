module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 0 registers (input processing)
    reg a_sign0, b_sign0;
    reg [7:0] a_exp0, b_exp0;
    reg [23:0] a_mant0, b_mant0;
    wire special_case = (a[30:0] == 0) || (b[30:0] == 0) || 
                       (&a[30:23] || &b[30:23]);

    // Pipeline stage 1 registers (multiplication)
    reg z_sign1;
    reg [7:0] z_exp1;
    reg [47:0] product1;

    // Pipeline stage 2 registers (normalization and rounding)
    reg z_sign2;
    reg [7:0] z_exp2;
    reg [22:0] z_mant2;

    // Stage 0: Input processing
    always @(posedge clk) begin
        a_sign0 <= a[31];
        b_sign0 <= b[31];
        a_exp0 <= a[30:23];
        b_exp0 <= b[30:23];
        a_mant0 <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
        b_mant0 <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    end

    // Stage 1: Multiplication and exponent
    always @(posedge clk) begin
        z_sign1 <= a_sign0 ^ b_sign0;
        z_exp1 <= a_exp0 + b_exp0 - 8'd127;
        product1 <= a_mant0 * b_mant0;
    end

    // Stage 2: Normalization and rounding
    wire [47:0] norm_product = product1[47] ? product1 : {product1[46:0], 1'b0};
    wire round = norm_product[23] & (norm_product[22] | |norm_product[21:0]);

    always @(posedge clk) begin
        z_sign2 <= z_sign1;
        if (product1[47]) begin
            z_exp2 <= z_exp1 + 1;
            z_mant2 <= product1[46:24] + round;
        end else begin
            z_exp2 <= z_exp1;
            z_mant2 <= product1[45:23] + round;
        end
    end

    // Output generation with special cases
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (special_case) begin
                if (&a[30:23] || &b[30:23]) begin // NaN or Inf
                    z <= {a_sign0^b_sign0, 8'hFF, (|a[22:0] | |b[22:0]) ? 23'h7FFFFF : 0};
                end else begin // Zero
                    z <= {a_sign0^b_sign0, 31'b0};
                end
            end else if (z_exp2[7] & ~z_exp2[6]) begin // Overflow
                z <= {z_sign2, 8'hFF, 23'b0};
            end else if (~|z_exp2) begin // Underflow
                z <= {z_sign2, 31'b0};
            end else begin // Normal case
                z <= {z_sign2, z_exp2, z_mant2};
            end
        end
    end

endmodule
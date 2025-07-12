module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline parameters
    parameter STAGES = 5;
    parameter STAGE_DECODE = 0;
    parameter STAGE_SPECIAL = 1;
    parameter STAGE_MULTIPLY = 2;
    parameter STAGE_NORMALIZE = 3;
    parameter STAGE_ROUND = 4;

    // Pipeline registers
    reg [31:0] pipe_a [0:STAGES-1];
    reg [31:0] pipe_b [0:STAGES-1];
    reg [STAGES-1:0] pipe_valid;

    // Special case detection signals
    wire a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    wire special_case, result_zero, result_inf, result_nan;

    // Normal path signals
    wire a_sign, b_sign;
    wire [7:0] a_exp, b_exp;
    wire [23:0] a_man, b_man;
    wire [9:0] exp_sum;
    wire [47:0] product;
    wire [4:0] leading_zeros;
    wire [23:0] rounded_mantissa;
    wire [7:0] final_exp;

    // Special case detection (combinational)
    assign a_zero = (a[30:0] == 0);
    assign b_zero = (b[30:0] == 0);
    assign a_inf = (a[30:23] == 8'hFF) & (a[22:0] == 0);
    assign b_inf = (b[30:23] == 8'hFF) & (b[22:0] == 0);
    assign a_nan = (a[30:23] == 8'hFF) & (a[22:0] != 0);
    assign b_nan = (b[30:23] == 8'hFF) & (b[22:0] != 0);

    assign special_case = a_zero | b_zero | a_inf | b_inf | a_nan | b_nan;
    assign result_nan = a_nan | b_nan | (a_zero & b_inf) | (a_inf & b_zero);
    assign result_inf = (a_inf | b_inf) & ~result_nan;
    assign result_zero = (a_zero | b_zero) & ~result_nan;

    // Pipeline control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (integer i = 0; i < STAGES; i = i+1) begin
                pipe_a[i] <= 0;
                pipe_b[i] <= 0;
                pipe_valid[i] <= 0;
            end
        end else begin
            // Shift pipeline
            for (integer i = 1; i < STAGES; i = i+1) begin
                pipe_a[i] <= pipe_a[i-1];
                pipe_b[i] <= pipe_b[i-1];
                pipe_valid[i] <= pipe_valid[i-1];
            end
            pipe_a[0] <= a;
            pipe_b[0] <= b;
            pipe_valid[0] <= 1;
        end
    end

    // Stage 1: Decode and special case detection
    assign a_sign = pipe_a[STAGE_DECODE][31];
    assign b_sign = pipe_b[STAGE_DECODE][31];
    assign a_exp = pipe_a[STAGE_DECODE][30:23];
    assign b_exp = pipe_b[STAGE_DECODE][30:23];
    assign a_man = (a_exp == 0) ? {1'b0, pipe_a[STAGE_DECODE][22:0]} : {1'b1, pipe_a[STAGE_DECODE][22:0]};
    assign b_man = (b_exp == 0) ? {1'b0, pipe_b[STAGE_DECODE][22:0]} : {1'b1, pipe_b[STAGE_DECODE][22:0]};

    // Stage 2: Early exponent prediction and special case handling
    assign exp_sum = {2'b0, a_exp} + {2'b0, b_exp} - 127;

    // Stage 3: Wallace-tree multiplier
    wallace_multiplier mult (
        .a(a_man),
        .b(b_man),
        .product(product)
    );

    // Stage 4: Leading-zero anticipation and normalization
    leading_zero_anticipator lza (
        .in(product[47:24]),
        .count(leading_zeros)
    );

    wire [47:0] normalized_product = product << (product[47] ? 0 : leading_zeros + 1);
    wire [9:0] adjusted_exp = product[47] ? (exp_sum + 1) : (exp_sum - leading_zeros);

    // Stage 5: Rounding and final assembly
    rounding_unit rounder (
        .mantissa(normalized_product[46:24]),
        .guard(normalized_product[23]),
        .round(normalized_product[22]),
        .sticky(|normalized_product[21:0]),
        .rounded(rounded_mantissa)
    );

    assign final_exp = (adjusted_exp > 254) ? 8'hFF : 
                      (adjusted_exp < 1) ? 8'h00 : 
                      adjusted_exp[7:0];

    // Output selection
    always @(*) begin
        if (!pipe_valid[STAGE_ROUND]) begin
            z = 0;
        end else if (result_nan) begin
            z = {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
        end else if (result_inf) begin
            z = {a_sign ^ b_sign, 8'hFF, 23'h0};
        end else if (result_zero) begin
            z = {a_sign ^ b_sign, 31'h0};
        end else if (adjusted_exp > 254) begin // Overflow
            z = {a_sign ^ b_sign, 8'hFF, 23'h0};
        end else if (adjusted_exp < 1) begin // Underflow
            z = {a_sign ^ b_sign, 31'h0};
        end else begin
            z = {a_sign ^ b_sign, final_exp, rounded_mantissa[22:0]};
        end
    end

endmodule

// Wallace-tree multiplier module
module wallace_multiplier (
    input [23:0] a,
    input [23:0] b,
    output reg [47:0] product
);
    // Implementation of 24x24 Wallace-tree multiplier using carry-save adders
    always @(*) begin
        product = a * b; // Simplified for illustration
    end
endmodule

// Leading-zero anticipator (fixed version)
module leading_zero_anticipator (
    input [23:0] in,
    output reg [4:0] count
);
    // Implementation of leading-zero counter using Verilog-2001 syntax
    reg found;
    integer i;
    
    always @(*) begin
        count = 0;
        found = 0;
        for (i = 23; i >= 0; i = i-1) begin
            if (!found && in[i]) begin
                count = 23 - i;
                found = 1;
            end
        end
    end
endmodule

// Rounding unit
module rounding_unit (
    input [22:0] mantissa,
    input guard,
    input round,
    input sticky,
    output reg [23:0] rounded
);
    // Round to nearest even
    always @(*) begin
        if (guard && (round || sticky || mantissa[0])) begin
            rounded = {1'b0, mantissa} + 1;
            if (rounded[23]) begin // Handle overflow
                rounded = {1'b1, rounded[23:1]};
            end
        end else begin
            rounded = {1'b0, mantissa};
        end
    end
endmodule
module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State machine parameters
    parameter IDLE = 2'b00;
    parameter PROCESS = 2'b01;
    parameter MULTIPLY = 2'b10;
    parameter NORMALIZE = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // Input registers
    reg [31:0] a_reg, b_reg;
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [23:0] a_mantissa, b_mantissa;

    // Pipeline registers
    reg [47:0] product;
    reg [9:0] exponent_sum;
    reg z_sign_pipe;

    // Special case flags
    wire a_is_zero, b_is_zero;
    wire a_is_inf, b_is_inf;
    wire a_is_nan, b_is_nan;
    wire z_is_nan, z_is_inf, z_is_zero;

    // Normalization signals
    wire [47:0] product_shifted;
    wire [9:0] z_exponent;
    wire [23:0] z_mantissa;
    wire exponent_overflow, exponent_underflow;

    // Combinational special case detection
    assign a_is_zero = (a_reg[30:0] == 0);
    assign b_is_zero = (b_reg[30:0] == 0);
    assign a_is_inf = (a_reg[30:23] == 8'hFF) && (a_reg[22:0] == 0);
    assign b_is_inf = (b_reg[30:23] == 8'hFF) && (b_reg[22:0] == 0);
    assign a_is_nan = (a_reg[30:23] == 8'hFF) && (a_reg[22:0] != 0);
    assign b_is_nan = (b_reg[30:23] == 8'hFF) && (b_reg[22:0] != 0);

    assign z_is_nan = a_is_nan | b_is_nan | (a_is_zero & b_is_inf) | (a_is_inf & b_is_zero);
    assign z_is_inf = (a_is_inf | b_is_inf) & ~z_is_nan;
    assign z_is_zero = (a_is_zero | b_is_zero) & ~z_is_nan;

    // State machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    a_reg <= a;
                    b_reg <= b;
                end
                PROCESS: begin
                    a_sign <= a_reg[31];
                    b_sign <= b_reg[31];
                    a_exponent <= a_reg[30:23];
                    b_exponent <= b_reg[30:23];
                    a_mantissa <= (a_reg[30:23] == 0) ? {1'b0, a_reg[22:0]} : {1'b1, a_reg[22:0]};
                    b_mantissa <= (b_reg[30:23] == 0) ? {1'b0, b_reg[22:0]} : {1'b1, b_reg[22:0]};
                end
                MULTIPLY: begin
                    product <= a_mantissa * b_mantissa;
                    exponent_sum <= {2'b0, a_exponent} + {2'b0, b_exponent} - 127;
                    z_sign_pipe <= a_sign ^ b_sign;
                end
                NORMALIZE: begin
                    // Output will be handled by combinational logic
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = PROCESS;
            PROCESS: next_state = MULTIPLY;
            MULTIPLY: next_state = NORMALIZE;
            NORMALIZE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Normalization and rounding
    assign product_shifted = product[47] ? product : (product << 1);
    assign z_exponent = product[47] ? (exponent_sum + 1) : exponent_sum;

    function [23:0] round_mantissa;
        input [47:0] product;
        input [9:0] exponent;
        reg guard, round, sticky;
        reg [23:0] mantissa;
        begin
            guard = product[22];
            round = product[21];
            sticky = |product[20:0];
            mantissa = product[46:24];
            
            // Round to nearest even
            if (guard && (round || sticky || mantissa[0])) begin
                round_mantissa = mantissa + 1;
                // Handle mantissa overflow
                if (round_mantissa[23]) begin
                    round_mantissa = {1'b1, round_mantissa[23:1]};
                end
            end else begin
                round_mantissa = mantissa;
            end
        end
    endfunction

    assign z_mantissa = round_mantissa(product_shifted, z_exponent);
    assign exponent_overflow = (z_exponent >= 255);
    assign exponent_underflow = (z_exponent <= 0);

    // Output logic
    always @(*) begin
        if (state == NORMALIZE) begin
            if (z_is_nan) begin
                z = {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
            end else if (z_is_inf) begin
                z = {z_sign_pipe, 8'hFF, 23'h0};
            end else if (z_is_zero) begin
                z = {z_sign_pipe, 31'h0};
            end else if (exponent_overflow) begin
                z = {z_sign_pipe, 8'hFF, 23'h0}; // Infinity
            end else if (exponent_underflow) begin
                z = {z_sign_pipe, 31'h0}; // Zero
            end else begin
                z = {z_sign_pipe, z_exponent[7:0], z_mantissa[22:0]};
            end
        end else begin
            z = 32'h0;
        end
    end

endmodule
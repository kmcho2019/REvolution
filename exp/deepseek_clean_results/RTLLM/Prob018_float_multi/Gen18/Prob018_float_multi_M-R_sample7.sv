module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // IEEE 754 constants
    parameter EXP_BIAS = 127;
    parameter EXP_MAX = 255;
    parameter MANT_WIDTH = 23;
    parameter TOTAL_WIDTH = 32;

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        PROCESS,
        NORMALIZE,
        ROUND
    } state_t;

    // State registers
    state_t current_state, next_state;

    // Data path registers
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mant, b_mant;
    reg [47:0] product;
    reg [7:0] z_exp;
    reg [23:0] z_mant;
    reg z_sign;
    reg guard, sticky;

    // Control signals
    wire is_special_case;
    wire is_nan;
    wire is_inf;
    wire is_zero;
    wire overflow;
    wire underflow;

    // Special case detection
    assign is_nan = (&a[30:23] && |a[22:0]) || (&b[30:23] && |b[22:0]);
    assign is_inf = (&a[30:23] && ~|a[22:0]) || (&b[30:23] && ~|b[22:0]);
    assign is_zero = ~|a[30:0] || ~|b[30:0];
    assign is_special_case = is_nan || is_inf || is_zero;

    // Overflow/underflow detection
    assign overflow = (z_exp >= EXP_MAX) && (current_state == NORMALIZE || current_state == ROUND);
    assign underflow = (z_exp == 0) && (current_state == NORMALIZE || current_state == ROUND);

    // State machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = PROCESS;
            PROCESS: next_state = NORMALIZE;
            NORMALIZE: next_state = ROUND;
            ROUND: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Data path - input processing
    always @(posedge clk) begin
        if (current_state == IDLE) begin
            a_sign <= a[31];
            b_sign <= b[31];
            a_exp <= a[30:23];
            b_exp <= b[30:23];
            a_mant <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mant <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
        end
    end

    // Data path - multiplication
    always @(posedge clk) begin
        if (current_state == PROCESS) begin
            product <= a_mant * b_mant;
            z_exp <= a_exp + b_exp - EXP_BIAS;
            z_sign <= a_sign ^ b_sign;
        end
    end

    // Data path - normalization
    always @(posedge clk) begin
        if (current_state == NORMALIZE) begin
            if (product[47]) begin
                z_mant <= product[47:24];
                z_exp <= z_exp + 1;
                guard <= product[23];
                sticky <= |product[22:0];
            end else begin
                z_mant <= product[46:23];
                guard <= product[22];
                sticky <= |product[21:0];
            end
        end
    end

    // Rounding function
    function [24:0] round;
        input [23:0] mant;
        input g, s;
        begin
            round = {1'b0, mant};
            if (g && (s || mant[0])) begin
                round = round + 1;
            end
        end
    endfunction

    // Data path - rounding and output
    always @(posedge clk) begin
        if (current_state == ROUND) begin
            if (is_special_case) begin
                if (is_nan) begin
                    z <= {1'b0, EXP_MAX, 1'b1, {MANT_WIDTH-1{1'b0}}};
                end else if (is_inf) begin
                    z <= {z_sign, EXP_MAX, {MANT_WIDTH{1'b0}}};
                end else begin // is_zero
                    z <= {z_sign, {TOTAL_WIDTH-1{1'b0}}};
                end
            end else if (overflow) begin
                z <= {z_sign, EXP_MAX, {MANT_WIDTH{1'b0}}};
            end else if (underflow) begin
                z <= {z_sign, {TOTAL_WIDTH-1{1'b0}}};
            end else begin
                {z_exp, z_mant} <= round(z_mant, guard, sticky);
                z <= {z_sign, z_exp, z_mant[22:0]};
            end
        end
    end

endmodule
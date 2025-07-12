module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Control unit signals
reg init_div;
reg div_step;
reg update_res;

// Datapath unit signals
reg [15:0] dividend_dp;
reg [7:0] divisor_dp;
reg [7:0] neg_divisor;
reg [15:0] quotient;
reg [7:0] remainder;

// State machine states
enum logic [2:0] {
    IDLE,
    INIT,
    DIVIDE,
    UPDATE_RES
} state, next_state;

// Control unit logic
always_comb begin
    case (state)
        IDLE: begin
            if (opn_valid && !res_valid) begin
                init_div = 1'b1;
                div_step = 1'b0;
                update_res = 1'b0;
            end else begin
                init_div = 1'b0;
                div_step = 1'b0;
                update_res = 1'b0;
            end
        end
        INIT: begin
            init_div = 1'b0;
            div_step = 1'b1;
            update_res = 1'b0;
        end
        DIVIDE: begin
            div_step = 1'b1;
            update_res = 1'b0;
        end
        UPDATE_RES: begin
            div_step = 1'b0;
            update_res = 1'b1;
        end
    endcase
end

// Datapath unit logic
always @(posedge clk) begin
    if (rst) begin
        dividend_dp <= 0;
        divisor_dp <= 0;
        neg_divisor <= 0;
        quotient <= 0;
        remainder <= 0;
    end else if (init_div) begin
        // Initialize datapath unit
        dividend_dp <= sign ? {{8{dividend[7]}}, dividend} : dividend;
        divisor_dp <= sign ? {{8{divisor[7]}}, divisor} : divisor;
        neg_divisor <= ~divisor_dp + 1;
        quotient <= 0;
        remainder <= 0;
    end else if (div_step) begin
        // Perform division step
        reg [8:0] sub_result;
        sub_result = {1'b0, remainder} - {1'b0, neg_divisor};
        if (sub_result[8]) begin
            remainder <= remainder;
            quotient <= quotient;
        end else begin
            remainder <= remainder + neg_divisor;
            quotient <= quotient + 1;
        end
        remainder <= remainder >> 1;
        quotient <= quotient >> 1;
    end else if (update_res) begin
        // Update result
        result <= {remainder, quotient};
        res_valid <= 1'b1;
    end
end

// State machine logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (init_div) begin
                    state <= INIT;
                end
            end
            INIT: begin
                state <= DIVIDE;
            end
            DIVIDE: begin
                if (div_step) begin
                    state <= DIVIDE;
                end else begin
                    state <= UPDATE_RES;
                end
            end
            UPDATE_RES: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule
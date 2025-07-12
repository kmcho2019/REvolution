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

// Define states for the FSM
enum logic [1:0] {IDLE, BUSY} state, next_state;

// Internal signals
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;  
reg [15:0] shift_reg;  
reg [3:0] cnt;
reg start_cnt;

// State register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        shift_reg <= 0;
    end else begin
        state <= next_state;
        if (next_state == BUSY) begin
            if (cnt == 8) begin
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end
        if (state == IDLE && opn_valid &&!res_valid) begin
            dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
            divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
            neg_divisor <= ~divisor_reg + 1;  
            shift_reg <= {8'b0, dividend_reg};  
            start_cnt <= 1;
            res_valid <= 0;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (opn_valid &&!res_valid) begin
                next_state = BUSY;
            end else begin
                next_state = IDLE;
            end
        end
        BUSY: begin
            if (cnt == 8) begin
                next_state = IDLE;
            end else begin
                next_state = BUSY;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Data path and output logic
always @(posedge clk) begin
    if (state == BUSY) begin
        if (cnt == 8) begin
            result <= {shift_reg[15:8], shift_reg[7:0]};  
            res_valid <= 1;
        end else begin
            if (shift_reg[15:8] >= divisor_reg) begin
                shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};  
            end else begin
                shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};  
            end
        end
    end else if (!opn_valid && res_valid) begin
        res_valid <= 0;
    end
end

endmodule
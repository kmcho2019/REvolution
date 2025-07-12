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

// Define states for the division process
typedef enum logic [1:0] {IDLE, DIVIDE, DONE} state_t;

state_t state, next_state;

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;

// Combinational logic for next state
always_comb begin
    case (state)
        IDLE: begin
            if (opn_valid && !res_valid) begin
                if (divisor == 0) begin
                    next_state = DONE;
                end else begin
                    next_state = DIVIDE;
                end
            end else begin
                next_state = IDLE;
            end
        end
        DIVIDE: begin
            if (cnt == 8) begin
                next_state = DONE;
            end else begin
                next_state = DIVIDE;
            end
        end
        DONE: begin
            if (!opn_valid) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
    endcase
end

// Combinational logic for shift_reg update
wire [15:0] shift_reg_next;
assign shift_reg_next = (shift_reg[15:8] >= divisor_reg) ? {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]} : {shift_reg[15:8], 1'b0, shift_reg[7:1]};

// Combinational logic for result
assign neg_divisor = ~divisor + 1;
wire [15:0] result_comb;
assign result_comb = {shift_reg[15:8], shift_reg[7:0]};

// Sequential logic
always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    if (divisor != 0) begin
                        dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                        divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                        shift_reg <= {8'b0, dividend_reg};
                        cnt <= 1;
                    end
                end
            end
            DIVIDE: begin
                shift_reg <= shift_reg_next;
                cnt <= cnt + 1;
            end
            DONE: begin
                result <= result_comb;
                res_valid <= 1;
            end
        endcase
    end
end

endmodule
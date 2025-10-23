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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;
reg [1:0] state; // 0: idle, 1: init, 2: divide
reg [1:0] next_state_reg; // Explicitly define next_state

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        state <= 2'b00;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        case (state)
            2'b00: begin // Idle
                if (opn_valid) begin
                    dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                    divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                    neg_divisor <= ~divisor_reg + 1;
                    shift_reg <= {8'b0, dividend_reg};
                    cnt <= 1; // Initialize cnt to 1 for the division process
                    start_cnt <= 1;
                    state <= 2'b01; // Transition to initialize state
                end
            end
            2'b01: begin // Initialize
                state <= 2'b10; // Transition to divide state
            end
            2'b10: begin // Divide
                if (cnt == 8) begin
                    result <= {shift_reg[15:8], shift_reg[7:0]};
                    res_valid <= 1;
                    state <= 2'b00; // Return to idle state
                end else begin
                    if (shift_reg[15:8] >= divisor_reg) begin
                        shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
                    end else begin
                        shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

// Result validity management
always @(posedge clk) begin
    if (rst || (!opn_valid && res_valid)) begin
        res_valid <= 0;
    end
end

endmodule
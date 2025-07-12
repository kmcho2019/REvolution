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

reg [1:0] state; // IDLE, INIT, DIVIDE, DONE
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;

// Combinational logic for next state and updated values
always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (opn_valid && !res_valid) begin
                state = 2'b01; // INIT
                dividend_reg = sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                divisor_reg = sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                neg_divisor = ~divisor_reg + 1;
                shift_reg = {8'b0, dividend_reg};
                cnt = 1;
                start_cnt = 1;
            end else begin
                state = 2'b00; // IDLE
            end
        end
        2'b01: begin // INIT
            state = 2'b10; // DIVIDE
        end
        2'b10: begin // DIVIDE
            if (cnt == 8) begin
                state = 2'b11; // DONE
                result = {shift_reg[15:8], shift_reg[7:0]};
                res_valid = 1;
            end else begin
                if (shift_reg[15:8] >= divisor_reg) begin
                    shift_reg = {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
                end else begin
                    shift_reg = {shift_reg[15:8], 1'b0, shift_reg[7:1]};
                end
                cnt = cnt + 1;
                state = 2'b10; // DIVIDE
            end
        end
        2'b11: begin // DONE
            if (!opn_valid) begin
                state = 2'b00; // IDLE
                res_valid = 0;
            end else begin
                state = 2'b11; // DONE
            end
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        state <= 2'b00;
        res_valid <= 0;
    end else begin
        state <= state;
        res_valid <= res_valid;
    end
end

endmodule
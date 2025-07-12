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

reg [2:0] state; // IDLE, INIT, DIVIDE, DONE
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;

// Combinational logic for next state and updated values
always @(*) begin
    case(state)
        3'b001: begin // IDLE
            if (opn_valid && !res_valid) begin
                state = 3'b010; // INIT
                dividend_reg = sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                divisor_reg = sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                neg_divisor = ~divisor_reg + 1;
                shift_reg = {8'b0, dividend_reg};
                cnt = 1;
            end else begin
                state = 3'b001; // IDLE
            end
        end
        3'b010: begin // INIT
            state = 3'b100; // DIVIDE
        end
        3'b100: begin // DIVIDE
            if (cnt == 8) begin
                state = 3'b000; // DONE
                result = {shift_reg[15:8], shift_reg[7:0]};
                res_valid = 1;
            end else begin
                reg [8:0] temp;
                temp = shift_reg[15:8] - divisor_reg;
                if (temp[8]) begin
                    shift_reg = {shift_reg[15:8], 1'b0, shift_reg[7:1]};
                end else begin
                    shift_reg = {temp[7:0], 1'b1, shift_reg[7:1]};
                end
                cnt = cnt + 1;
                state = 3'b100; // DIVIDE
            end
        end
        default: begin
            if (!opn_valid) begin
                state = 3'b001; // IDLE
                res_valid = 0;
            end
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b001;
        res_valid <= 0;
    end else begin
        // No need for sequential update of state and res_valid
    end
end

endmodule
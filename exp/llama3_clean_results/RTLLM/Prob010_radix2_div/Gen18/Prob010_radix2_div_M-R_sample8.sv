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
enum logic [1:0] {IDLE, DIVIDE, DONE} state, next_state;

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;

// Combinational logic
assign neg_divisor = ~divisor_reg + 1;

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    if (divisor == 0) begin
                        // Handle division by zero error
                        result <= 16'hFFFF; // or any other suitable output
                        res_valid <= 1;
                        state <= DONE;
                    end else begin
                        dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                        divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                        shift_reg <= {8'b0, dividend_reg};
                        cnt <= 1; // Initialize cnt to 1 for the division process
                        state <= DIVIDE;
                    end
                end
            end
            DIVIDE: begin
                if (cnt == 8) begin
                    result <= {shift_reg[15:8], shift_reg[7:0]};
                    res_valid <= 1;
                    state <= DONE;
                end else begin
                    if (shift_reg[15:8] >= divisor_reg) begin
                        shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
                    end else begin
                        shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
                    end
                    cnt <= cnt + 1;
                end
            end
            DONE: begin
                if (!opn_valid) begin
                    res_valid <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule
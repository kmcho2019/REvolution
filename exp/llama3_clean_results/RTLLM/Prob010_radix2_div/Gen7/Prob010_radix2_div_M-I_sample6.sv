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

// Define the states of the state machine
enum logic [1:0] {IDLE, OPERATING, DONE} state;

// Initialize the state machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    state <= OPERATING;
                end
            end
            OPERATING: begin
                if (cnt == 8) begin
                    state <= DONE;
                end
            end
            DONE: begin
                if (!opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Define the registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [8:0] shift_reg;
reg [3:0] cnt;

// Initialize the registers
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    // Initialize the registers
                    dividend_reg <= sign ? {{8{dividend[7]}}, dividend[7:0]} : dividend;
                    divisor_reg <= sign ? {{8{divisor[7]}}, divisor[7:0]} : divisor;
                    shift_reg <= {1'b0, dividend_reg};  // shift left by one bit
                    cnt <= 1;
                end
            end
            OPERATING: begin
                // Update the shift register
                if (cnt < 8) begin
                    if (shift_reg[8] == 0) begin
                        // Subtract divisor
                        if (shift_reg[7:0] >= divisor_reg) begin
                            shift_reg <= {1'b0, shift_reg[7:0] - divisor_reg} << 1;  // shift left and insert carry-out
                        end else begin
                            shift_reg <= {1'b1, shift_reg[7:0]} << 1;  // shift left and insert carry-out
                        end
                    end else begin
                        // Subtract divisor
                        if ({shift_reg[8], shift_reg[7:0]} >= {1'b0, divisor_reg}) begin
                            shift_reg <= {1'b0, shift_reg[7:0] - divisor_reg} << 1;  // shift left and insert carry-out
                        end else begin
                            shift_reg <= {1'b1, shift_reg[7:0]} << 1;  // shift left and insert carry-out
                        end
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

// Update the result
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            DONE: begin
                res_valid <= 1;
                // Update the result
                if (sign) begin
                    // Signed division
                    if (dividend[7] == 1'b1) begin
                        result <= {~(shift_reg[8:1] + 1), shift_reg[0]};
                    end else begin
                        result <= {shift_reg[8:1], shift_reg[0]};
                    end
                end else begin
                    // Unsigned division
                    result <= {shift_reg[8:1], shift_reg[0]};
                end
            end
            IDLE: begin
                res_valid <= 0;
            end
        endcase
    end
end

endmodule
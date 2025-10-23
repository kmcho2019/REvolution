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
        res_valid <= 0;
        result <= 0;
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
reg [7:0] quotient;
reg [7:0] remainder;
reg [3:0] cnt;
reg carry;

// Initialize the registers
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient <= 0;
        remainder <= 0;
        cnt <= 0;
        carry <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    // Initialize the registers
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    remainder <= {1'b0, dividend_reg};
                    cnt <= 1;
                    carry <= 0;
                end
            end
            OPERATING: begin
                // Update the quotient and remainder
                if (cnt < 8) begin
                    reg [9:0] temp;
                    temp = {carry, remainder};
                    if (temp[8]) begin
                        quotient <= quotient + (1 << (8 - cnt));
                        remainder <= temp[7:0] - divisor_reg;
                        carry <= temp[8];
                    end else begin
                        remainder <= temp[7:0];
                        carry <= temp[8];
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
                    if (dividend_reg[7] == 1'b1) begin
                        result <= {{8{remainder[7]}}, remainder} + {{8{1'b1}}, ~quotient + 1'b1};
                    end else begin
                        result <= {remainder, quotient};
                    end
                end else begin
                    // Unsigned division
                    result <= {remainder, quotient};
                end
            end
            IDLE: begin
                res_valid <= 0;
            end
        endcase
    end
end

endmodule
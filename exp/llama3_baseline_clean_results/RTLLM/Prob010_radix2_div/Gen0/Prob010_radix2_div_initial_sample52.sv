module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [8:0] sr;  // Shift register with 1 extra bit for sign
reg [2:0] cnt;  // Counter for division steps
reg start_cnt;  // Flag to start the division process
reg [7:0] quotient;
reg [7:0] remainder;

// FSM states
reg [1:0] state;
localparam IDLE = 2'd0;
localparam START = 2'd1;
localparam DIVIDE = 2'd2;

// Assign the output result
assign result = {remainder, quotient};

// Sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        neg_divisor <= 8'd0;
        sr <= 9'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid <= 1'd0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    // Save the inputs and initialize the shift register
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    if (sign) begin
                        // Signed division
                        if (dividend[7]) begin
                            dividend_reg <= ~dividend + 1;
                        end
                        if (divisor[7]) begin
                            divisor_reg <= ~divisor + 1;
                            neg_divisor <= ~divisor_reg + 1;
                        end else begin
                            neg_divisor <= ~divisor_reg;
                        end
                    end else begin
                        // Unsigned division
                        neg_divisor <= ~divisor_reg;
                    end
                    sr <= {1'd0, dividend_reg};  // Initialize shift register
                    cnt <= 3'd1;
                    start_cnt <= 1'd1;
                    state <= START;
                end
            end
            START: begin
                if (start_cnt) begin
                    state <= DIVIDE;
                end
            end
            DIVIDE: begin
                if (cnt == 3'd8) begin
                    // Division complete
                    cnt <= 3'd0;
                    start_cnt <= 1'd0;
                    state <= IDLE;
                    res_valid <= 1'd1;
                    quotient <= sr[7:0];
                    remainder <= sr[8];
                end else begin
                    // Perform the division step
                    reg [8:0] temp;
                    temp = sr - {1'd0, neg_divisor};
                    if (temp[8]) begin
                        // Borrow occurred, quotient bit is 0
                        sr <= {1'd0, sr} << 1;
                    end else begin
                        // No borrow, quotient bit is 1
                        sr <= {1'd1, sr} << 1;
                    end
                    cnt <= cnt + 1'd1;
                end
            end
        endcase
    end
end

// Output valid signal
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'd0;
    end else begin
        if (state == IDLE && opn_valid) begin
            res_valid <= 1'd0;
        end else if (cnt == 3'd8) begin
            res_valid <= 1'd1;
        end
    end
end

endmodule
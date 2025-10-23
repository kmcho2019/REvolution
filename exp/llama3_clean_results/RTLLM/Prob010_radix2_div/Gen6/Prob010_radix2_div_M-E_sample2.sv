module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Internal signals
reg [7:0] dividend_reg, divisor_reg;
reg [7:0] quotient, remainder;
reg [2:0] cnt;
reg start_div;
reg [15:0] temp_result;

// FSM states
localparam IDLE = 2'b00;
localparam DIVIDE = 2'b01;
localparam RESULT = 2'b10;
reg [1:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient <= 0;
        remainder <= 0;
        cnt <= 0;
        start_div <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    // Capture inputs
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    start_div <= 1;
                    state <= DIVIDE;
                end
            end
            DIVIDE: begin
                if (cnt == 8) begin
                    // Division complete
                    state <= RESULT;
                end else begin
                    // Perform division step
                    if (dividend_reg >= divisor_reg) begin
                        dividend_reg <= dividend_reg - divisor_reg;
                        quotient[cnt] <= 1;
                    end
                    dividend_reg <= dividend_reg << 1;
                    cnt <= cnt + 1;
                end
            end
            RESULT: begin
                // Prepare result
                remainder <= dividend_reg;
                temp_result <= {remainder, quotient};
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

assign result = temp_result;

// Reset res_valid when opn_valid goes low
always @(posedge clk) begin
    if (rst || !opn_valid) begin
        res_valid <= 0;
    end
end

endmodule
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

reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_div;

// State machine states
localparam IDLE = 2'b00;
localparam DIVIDE = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        remainder <= 0;
        quotient <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_div <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    remainder <= sign ? (dividend[7] ? (~dividend + 1) : dividend) : dividend;
                    neg_divisor <= sign ? (~divisor + 1) : divisor;
                    start_div <= 1'b1;
                    cnt <= 3'd1;
                    state <= DIVIDE;
                end
            end
            DIVIDE: begin
                if (cnt == 3'd8) begin
                    res_valid <= 1;
                    result <= {remainder, quotient};
                    state <= DONE;
                end else begin
                    if (remainder >= neg_divisor) begin
                        remainder <= remainder - neg_divisor;
                        quotient <= quotient + (1 << (8 - cnt));
                    end
                    remainder <= {remainder[6:0], 1'b0};
                    cnt <= cnt + 1'd1;
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
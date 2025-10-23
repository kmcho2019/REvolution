module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [7:0] state; // 8 bits for one-hot encoding
reg disc_reg, flag_reg, err_reg;
reg [2:0] cnt; // counter for consecutive ones

// One-hot encoding for states
localparam IDLE = 8'b00000001;
localparam ONE = 8'b00000010;
localparam TWO_ONES = 8'b00000100;
localparam THREE_ONES = 8'b00001000;
localparam FOUR_ONES = 8'b00010000;
localparam FIVE_ONES = 8'b00100000;
localparam SIX_ONES = 8'b01000000;
localparam SEVEN_ONES = 8'b10000000;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        cnt <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONE;
                    cnt <= 1;
                end else begin
                    state <= IDLE;
                    cnt <= 0;
                end
            end
            ONE: begin
                if (in) begin
                    state <= TWO_ONES;
                    cnt <= cnt + 1;
                end else begin
                    state <= IDLE;
                    cnt <= 0;
                end
            end
            TWO_ONES: begin
                if (in) begin
                    state <= THREE_ONES;
                    cnt <= cnt + 1;
                end else begin
                    state <= IDLE;
                    cnt <= 0;
                end
            end
            THREE_ONES: begin
                if (in) begin
                    state <= FOUR_ONES;
                    cnt <= cnt + 1;
                end else begin
                    state <= IDLE;
                    cnt <= 0;
                end
            end
            FOUR_ONES: begin
                if (in) begin
                    state <= FIVE_ONES;
                    cnt <= cnt + 1;
                end else begin
                    state <= IDLE;
                    cnt <= 0;
                end
            end
            FIVE_ONES: begin
                if (in) begin
                    state <= SIX_ONES;
                    cnt <= cnt + 1;
                end else begin
                    state <= IDLE;
                    disc_reg <= 1;
                    cnt <= 0;
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                    cnt <= 0;
                end
            end
            SEVEN_ONES: begin
                if (~in) begin
                    state <= IDLE;
                    cnt <= 0;
                end else begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule
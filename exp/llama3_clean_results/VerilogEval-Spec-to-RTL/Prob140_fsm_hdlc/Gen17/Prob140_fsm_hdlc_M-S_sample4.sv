module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [3:0] state; // 4 bits to represent 5 states (simplified)
reg disc_reg, flag_reg, err_reg;

localparam IDLE = 4'b0000;
localparam ONE = 4'b0001;
localparam FIVE_ONES = 4'b0101;
localparam SIX_ONES = 4'b0110;
localparam SEVEN_ONES = 4'b0111;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (state)
            IDLE: begin
                if (in) state <= ONE;
                else state <= IDLE;
            end
            ONE: begin
                if (in) state <= (state + 1);
                else state <= IDLE;
            end
            FIVE_ONES: begin
                if (in) state <= SIX_ONES;
                else begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                end
            end
            SEVEN_ONES: begin
                if (~in) state <= IDLE;
                else begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule
module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

parameter IDLE = 2'b00;
parameter ONE = 2'b01;
parameter ONES_2 = 2'b10;
parameter ONES_3 = 2'b11;

reg [1:0] state;
reg [1:0] nextState;
reg disc_reg, flag_reg, err_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        state <= nextState;
        disc_reg <= (nextState == ONES_3);
        flag_reg <= (nextState == 2'b10);
        err_reg <= (nextState == 2'b11);
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if (in == 1'b1) begin
                nextState = ONE;
            end else begin
                nextState = IDLE;
            end
        end
        ONE: begin
            if (in == 1'b1) begin
                nextState = 2'b10; // State after first 1, moving towards ONES_2
            end else begin
                nextState = IDLE;
            end
        end
        2'b10: begin
            if (in == 1'b1) begin
                nextState = 2'b11; // Moving to ONES_3
            end else begin
                nextState = IDLE;
            end
        end
        2'b11: begin
            if (in == 1'b1) begin
                nextState = 2'b11; // Stay in ONES_3 if more 1s come
            end else begin
                nextState = IDLE;
            end
        end
        default: nextState = IDLE;
    endcase
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule
module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state
reg [2:0] count; // Counter for consecutive 1s
reg disc_reg, flag_reg, err_reg; // Output registers
reg disc_next, flag_next, err_next; // Next output values

parameter IDLE = 3'b000;
parameter FLAG_WAIT = 3'b001;
parameter DISCARD_WAIT = 3'b010;
parameter FLAG_DETECT = 3'b011;
parameter ERROR_DETECT = 3'b100;

always @(*) begin
    // Default values
    disc_next = 0;
    flag_next = 0;
    err_next = 0;

    // State transitions
    case (state)
        IDLE: begin
            if (in) begin
                nextState = FLAG_WAIT;
                count = count + 1;
            end else begin
                nextState = IDLE;
                count = 0;
            end
        end
        FLAG_WAIT: begin
            if (in) begin
                if (count == 5) begin
                    nextState = DISCARD_WAIT;
                    count = count + 1;
                end else if (count == 6) begin
                    nextState = FLAG_DETECT;
                    count = 0;
                end else if (count > 6) begin
                    nextState = ERROR_DETECT;
                    count = count + 1;
                end else begin
                    nextState = FLAG_WAIT;
                    count = count + 1;
                end
            end else begin
                nextState = IDLE;
                count = 0;
            end
        end
        DISCARD_WAIT: begin
            if (!in) begin
                nextState = IDLE;
                count = 0;
                disc_next = 1;
            end else begin
                nextState = FLAG_WAIT;
                count = count + 1;
            end
        end
        FLAG_DETECT: begin
            nextState = IDLE;
            count = 0;
            flag_next = 1;
        end
        ERROR_DETECT: begin
            if (!in) begin
                nextState = IDLE;
                count = 0;
            end else begin
                nextState = ERROR_DETECT;
                count = count + 1;
            end
            err_next = 1;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        state <= nextState;
        disc_reg <= disc_next;
        flag_reg <= flag_next;
        err_reg <= err_next;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule
module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define states
enum logic [3:0] {
    IDLE = 4'b0000,
    ONES_1 = 4'b0001,
    ONES_2 = 4'b0010,
    ONES_3 = 4'b0011,
    ONES_4 = 4'b0100,
    ONES_5 = 4'b0101,
    ONES_6 = 4'b0110,
    DISCARD = 4'b0111,
    FLAG = 4'b1000,
    ERROR = 4'b1001
} state, nextState;

// Output logic
always_comb begin
    disc = (state == DISCARD);
    flag = (state == FLAG);
    err = (state == ERROR);
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in) begin
                nextState = ONES_1;
            end else begin
                nextState = IDLE;
            end
        end
        ONES_1: begin
            if (in) begin
                nextState = ONES_2;
            end else begin
                nextState = IDLE;
            end
        end
        ONES_2: begin
            if (in) begin
                nextState = ONES_3;
            end else begin
                nextState = IDLE;
            end
        end
        ONES_3: begin
            if (in) begin
                nextState = ONES_4;
            end else begin
                nextState = IDLE;
            end
        end
        ONES_4: begin
            if (in) begin
                nextState = ONES_5;
            end else begin
                nextState = IDLE;
            end
        end
        ONES_5: begin
            if (in) begin
                nextState = ONES_6;
            end else begin
                nextState = IDLE;
            end
        end
        ONES_6: begin
            if (in) begin
                nextState = FLAG;
            end else begin
                nextState = DISCARD;
            end
        end
        FLAG: begin
            if (in) begin
                nextState = ERROR;
            end else begin
                nextState = IDLE;
            end
        end
        DISCARD: begin
            if (in) begin
                nextState = ONES_1;
            end else begin
                nextState = IDLE;
            end
        end
        ERROR: begin
            if (~in) begin
                nextState = IDLE;
            end else begin
                nextState = ERROR;
            end
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

// Update state
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

endmodule
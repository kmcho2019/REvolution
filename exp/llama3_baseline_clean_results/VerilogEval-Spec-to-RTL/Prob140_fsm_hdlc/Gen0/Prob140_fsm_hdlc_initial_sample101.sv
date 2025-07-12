module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // state variable
reg [2:0] nextState; // next state variable
reg disc_reg, flag_reg, err_reg; // registers for output signals

// State encoding:
// 0: Initial state (assuming previous input was 0)
// 1: 1 encountered
// 2: 2 consecutive 1s
// 3: 3 consecutive 1s
// 4: 4 consecutive 1s
// 5: 5 consecutive 1s
// 6: Error state (7 or more consecutive 1s)
// 7: Flag state (6 consecutive 1s and then 0)

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end
    else begin
        state <= nextState;
        disc_reg <= (nextState == 5 && state == 7) ? 1 : 0;
        flag_reg <= (nextState == 7 && state == 5) ? 1 : 0;
        err_reg <= (nextState == 6) ? 1 : 0;
    end
end

always @(*) begin
    case (state)
        0: begin
            if (in) begin
                nextState = 1;
            end
            else begin
                nextState = 0;
            end
        end
        1: begin
            if (in) begin
                nextState = 2;
            end
            else begin
                nextState = 0;
            end
        end
        2: begin
            if (in) begin
                nextState = 3;
            end
            else begin
                nextState = 0;
            end
        end
        3: begin
            if (in) begin
                nextState = 4;
            end
            else begin
                nextState = 0;
            end
        end
        4: begin
            if (in) begin
                nextState = 5;
            end
            else begin
                nextState = 0;
            end
        end
        5: begin
            if (in) begin
                nextState = 7; // Flag sequence
            end
            else begin
                nextState = 6; // Discard bit
            end
        end
        6: begin
            if (in) begin
                nextState = 6; // Stay in error state
            end
            else begin
                nextState = 0;
            end
        end
        7: begin
            if (in) begin
                nextState = 6; // Error state
            end
            else begin
                nextState = 0;
            end
        end
        default: begin
            nextState = 0;
        end
    endcase
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule
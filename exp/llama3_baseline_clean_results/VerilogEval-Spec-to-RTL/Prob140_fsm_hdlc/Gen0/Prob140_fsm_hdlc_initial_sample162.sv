module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states
reg [2:0] nextState;

always @(*) begin
    case(state)
        0: begin
            if (in) nextState = 1;
            else nextState = 0;
            disc = 0;
            flag = 0;
            err = 0;
        end
        1: begin
            if (in) nextState = 2;
            else nextState = 0;
            disc = 0;
            flag = 0;
            err = 0;
        end
        2: begin
            if (in) nextState = 3;
            else nextState = 0;
            disc = 0;
            flag = 0;
            err = 0;
        end
        3: begin
            if (in) nextState = 4;
            else nextState = 0;
            disc = 0;
            flag = 0;
            err = 0;
        end
        4: begin
            if (in) nextState = 5;
            else nextState = 0;
            disc = 0;
            flag = 0;
            err = 0;
        end
        5: begin
            if (in) nextState = 6;
            else begin
                nextState = 0;
                disc = 1;
            end
            flag = 0;
            err = 0;
        end
        6: begin
            if (in) begin
                nextState = 7;
                err = 1;
            end
            else begin
                nextState = 0;
                flag = 1;
            end
            disc = 0;
        end
        7: begin
            if (in) begin
                nextState = 7;
                err = 1;
            end
            else begin
                nextState = 0;
                err = 0;
            end
            disc = 0;
            flag = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) state <= 0;
    else state <= nextState;
end

endmodule
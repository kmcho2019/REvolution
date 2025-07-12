module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 8 states: 0 to 7
reg [2:0] nextState;

// Output logic
assign disc = (state == 5 && ~in);
assign flag = (state == 6);
assign err = (state >= 7);

// Next state logic
always @(*) begin
    case(state)
        0: nextState = (in) ? 1 : 0;
        1: nextState = (in) ? 2 : 0;
        2: nextState = (in) ? 3 : 0;
        3: nextState = (in) ? 4 : 0;
        4: nextState = (in) ? 5 : 0;
        5: nextState = (in) ? 6 : (in) ? 1 : 0; // insert zero after 5 consecutive 1s
        6: nextState = (in) ? 7 : 0;
        7: nextState = (in) ? 7 : 0; // stay in error state until 0 is seen
        default: nextState = 0;
    endcase
end

// State register
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
    end else begin
        state <= nextState;
    end
end

endmodule
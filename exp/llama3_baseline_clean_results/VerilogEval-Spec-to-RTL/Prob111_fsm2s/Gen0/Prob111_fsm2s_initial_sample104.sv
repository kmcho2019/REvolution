module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // Current state
reg [0:0] next_state; // Next state

always @(*) begin
    case(state)
        0: // OFF state
            if(j == 1) next_state = 1;
            else next_state = 0;
        1: // ON state
            if(k == 1) next_state = 0;
            else next_state = 1;
        default: next_state = 0;
    endcase
end

always @(posedge clk) begin
    if(reset) state <= 0;
    else state <= next_state;
end

always @(*) begin
    case(state)
        0: out = 0; // OFF state output
        1: out = 1; // ON state output
        default: out = 0;
    endcase
end

endmodule
module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // 2 states: OFF (0), ON (1)
reg [1:0] next_state;

always @(*) begin
    case(state)
        0: begin // OFF state
            if(j == 1) next_state = 1; // transition to ON state
            else next_state = 0; // stay in OFF state
        end
        1: begin // ON state
            if(k == 1) next_state = 0; // transition to OFF state
            else next_state = 1; // stay in ON state
        end
        default: next_state = 0; // default to OFF state if state is unknown
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) state <= 0; // asynchronous reset to OFF state
    else state <= next_state;
end

always @(state) begin
    case(state)
        0: out = 0; // OFF state output
        1: out = 1; // ON state output
        default: out = 0; // default to OFF state output if state is unknown
    endcase
end

endmodule
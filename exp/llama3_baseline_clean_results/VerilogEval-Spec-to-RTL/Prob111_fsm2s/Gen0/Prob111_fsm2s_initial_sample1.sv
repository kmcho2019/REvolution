module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit reg for two states: OFF (0) and ON (1)
reg [0:0] next_state;

always @(*) begin
    case(state)
        0: begin // OFF state
            if(j == 1'b1) next_state = 1'b1; // transition to ON if j = 1
            else next_state = 1'b0; // stay in OFF if j = 0
        end
        1: begin // ON state
            if(k == 1'b1) next_state = 1'b0; // transition to OFF if k = 1
            else next_state = 1'b1; // stay in ON if k = 0
        end
    endcase
end

always @(posedge clk) begin
    if(reset) state <= 1'b0; // synchronous reset to OFF state
    else state <= next_state;
end

assign out = state; // output determined by current state

endmodule
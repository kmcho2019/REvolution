module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state;  // 1-bit state variable
reg [0:0] next_state;

always @(areset or state or in) begin
    case(state)
        1'b0: next_state = (in == 1'b0) ? 1'b1 : 1'b0;
        1'b1: next_state = (in == 1'b0) ? 1'b0 : 1'b1;
        default: next_state = 1'b1;  // default state
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1;  // reset to state B
    end else begin
        state <= next_state;
    end
end

assign out = state;  // Moore machine output depends on the current state

endmodule
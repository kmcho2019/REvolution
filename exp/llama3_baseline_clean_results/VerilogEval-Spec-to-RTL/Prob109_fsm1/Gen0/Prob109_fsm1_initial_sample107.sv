module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 1 for B, 0 for A
reg [0:0] next_state;

always @(areset or state or in) begin
    case(state)
        1'b1: next_state = (in) ? 1'b1 : 1'b0; // State B
        1'b0: next_state = (in) ? 1'b0 : 1'b1; // State A
        default: next_state = 1'b1; // Default state
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

assign out = state;

endmodule
module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 1 bit to represent two states (0 - A, 1 - B)
reg [0:0] next_state;

// Asynchronous reset to state B
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1; // State B
    end else begin
        case(state)
            1: if (~in) next_state <= 0; // State B to State A if in is 0
                else next_state <= 1; // State B stays in State B if in is 1
            0: if (~in) next_state <= 1; // State A to State B if in is 0
                else next_state <= 0; // State A stays in State A if in is 1
        endcase
        state <= next_state;
    end
end

// Output is determined by current state (Moore machine)
assign out = state;

endmodule
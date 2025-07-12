module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using 1-bit state encoding: A=0, B=1
reg [0:0] next_state;

always @(*) begin
    case(state)
        0: begin // State A
            if (in) next_state = 0; // Stay in A
            else next_state = 1; // Transition to B
        end
        1: begin // State B
            if (in) next_state = 1; // Stay in B
            else next_state = 0; // Transition to A
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= 1; // Asynchronous reset to state B
    else state <= next_state;
end

assign out = state; // Output 'out' is a function of the current state

endmodule
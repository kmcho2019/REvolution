module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // 1-bit signal to represent the current state
reg [0:0] next_state;

always @(*) begin
    case (state)
        0: begin // State B
            if (in == 0) next_state = 1; // Transition to state A
            else next_state = 0; // Stay in state B
            out = 1; // Output is 1 in state B
        end
        1: begin // State A
            if (in == 0) next_state = 0; // Transition to state B
            else next_state = 1; // Stay in state A
            out = 0; // Output is 0 in state A
        end
        default: begin
            next_state = 0;
            out = 1;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state B
    end else begin
        state <= next_state;
    end
end

endmodule
module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 1-bit signal to represent the state
reg [0:0] next_state; // 1-bit signal to represent the next state

always @(*) begin
    case(state)
        1'b0: begin // State A
            if (~in) begin
                next_state = 1'b1; // Transition to state B
            end else begin
                next_state = 1'b0; // Stay in state A
            end
        end
        1'b1: begin // State B
            if (in) begin
                next_state = 1'b1; // Stay in state B
            end else begin
                next_state = 1'b0; // Transition to state A
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronously reset to state B
    end else begin
        state <= next_state; // Synchronously update the state
    end
end

always @(*) begin
    case(state)
        1'b0: out = 1'b0; // Output in state A
        1'b1: out = 1'b1; // Output in state B
    endcase
end

endmodule
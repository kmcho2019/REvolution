module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Current state (0 for A, 1 for B)
reg [0:0] next_state; // Next state

always @(*) begin
    case(state)
        1'b0: begin // State A
            if (!in) begin
                next_state = 1'b1; // Transition to B on 0
            end else begin
                next_state = 1'b0; // Stay in A on 1
            end
        end
        1'b1: begin // State B
            if (!in) begin
                next_state = 1'b0; // Transition to A on 0
            end else begin
                next_state = 1'b1; // Stay in B on 1
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronous reset to state B
    end else begin
        state <= next_state;
    end
end

assign out = state; // Output is the current state

endmodule
module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using reg to represent the state, initialized to 0 (state A) but will be reset to 1 (state B) if areset is high
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case (state)
            1'b0: begin // State A
                if (~in) begin
                    state <= 1'b1; // Move to state B if in is 0
                end else begin
                    state <= 1'b0; // Stay in state A if in is 1
                end
            end
            1'b1: begin // State B
                if (~in) begin
                    state <= 1'b0; // Move to state A if in is 0
                end else begin
                    state <= 1'b1; // Stay in state B if in is 1
                end
            end
        endcase
    end
end

// Output is determined solely by the state (Moore machine)
assign out = state;

endmodule
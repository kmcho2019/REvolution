module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg state; // One-hot encoding for state A
reg next_state;

assign z = (state) ? ~x : x; // Directly assign z based on state and x

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        case(state)
            1'b0: begin // State A
                if(x) begin
                    state <= 1'b1; // Transition to B
                end else begin
                    state <= 1'b0; // Stay in A
                end
            end
            1'b1: begin // State B
                state <= 1'b1; // Stay in B
            end
            default: state <= 1'b0; // Default to state A
        endcase
    end
end

endmodule
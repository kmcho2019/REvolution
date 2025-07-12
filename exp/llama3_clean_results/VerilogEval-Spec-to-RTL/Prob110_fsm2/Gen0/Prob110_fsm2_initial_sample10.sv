module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit signal to represent the current state
reg [0:0] nextState; // 1-bit signal to represent the next state

// Asynchronous active-high reset to state OFF
always @(posedge areset or posedge clk) begin
    if(areset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        // State transitions
        case(state)
            1'b0: begin // OFF state
                if(j) begin
                    state <= 1'b1; // Transition to ON state
                end else begin
                    state <= 1'b0; // Stay in OFF state
                end
            end
            1'b1: begin // ON state
                if(k) begin
                    state <= 1'b0; // Transition to OFF state
                end else begin
                    state <= 1'b1; // Stay in ON state
                end
            end
        endcase
    end
end

// Output calculation based on the current state
always @(*) begin
    case(state)
        1'b0: out = 1'b0; // Output 0 in OFF state
        1'b1: out = 1'b1; // Output 1 in ON state
    endcase
end

endmodule
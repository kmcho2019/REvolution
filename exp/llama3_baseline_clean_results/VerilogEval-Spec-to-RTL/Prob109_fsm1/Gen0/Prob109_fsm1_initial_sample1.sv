module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 0 represents state A, 1 represents state B

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        case(state)
            1: begin // State B
                if (~in) begin
                    state <= 0; // Move to state A if input is 0
                end else begin
                    state <= 1; // Stay in state B if input is 1
                end
            end
            0: begin // State A
                if (~in) begin
                    state <= 1; // Move to state B if input is 0
                end else begin
                    state <= 0; // Stay in state A if input is 1
                end
            end
        endcase
    end
end

// Output logic
always @(state) begin
    case(state)
        1: out <= 1; // Output is 1 in state B
        0: out <= 0; // Output is 0 in state A
    endcase
end

endmodule
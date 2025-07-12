module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg state; // 1-bit signal to represent the current state
initial state = 1; // Initialize state to B (1)

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset to state B
    end else begin
        case (state)
            1: begin // Current state is B
                if (!in) begin
                    state <= 0; // Next state is A
                end
            end
            0: begin // Current state is A
                if (!in) begin
                    state <= 1; // Next state is B
                end
            end
        endcase
    end
end

assign out = state; // Output is 1 when state is B, 0 when state is A

endmodule
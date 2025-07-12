module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot encoding for states: A (000), B (001), C (010), D (011)
reg [3:0] state;

// Initialize state to A (000) at reset
initial state = 4'b0001;

always @(posedge clk) begin
    if (~resetn) state <= 4'b0001; // Reset to state A
    else begin
        case (1'b1) // One-hot decoding for simplicity
            state[0]: begin // State A
                if (r[0]) state <= 4'b0010; // Transition to B
                else if (r[1]) state <= 4'b0100; // Transition to C
                else if (r[2]) state <= 4'b1000; // Transition to D
                else state <= 4'b0001; // Stay in A
            end
            state[1]: begin // State B
                if (r[0]) state <= 4'b0010; // Stay in B
                else state <= 4'b0001; // Transition back to A
            end
            state[2]: begin // State C
                if (r[1]) state <= 4'b0100; // Stay in C
                else state <= 4'b0001; // Transition back to A
            end
            state[3]: begin // State D
                if (r[2]) state <= 4'b1000; // Stay in D
                else state <= 4'b0001; // Transition back to A
            end
            default: state <= 4'b0001; // Default back to A
        endcase
    end
end

// Output logic based on one-hot state encoding
assign g[0] = state[1]; // B state
assign g[1] = state[2]; // C state
assign g[2] = state[3]; // D state

endmodule
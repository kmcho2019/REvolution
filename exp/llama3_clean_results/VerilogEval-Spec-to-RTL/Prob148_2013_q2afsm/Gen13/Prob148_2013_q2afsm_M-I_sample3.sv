module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Use one-hot encoding for states to potentially simplify logic
reg [3:0] state;

// Initialize state to the reset state (A) on reset
always @(posedge clk) begin
    if (~resetn) state <= 4'b0001;
    else begin
        case (1'b1)
            state[0]: begin // State A
                if (r[0]) state <= 4'b0010; // Priority to device 0
                else if (r[1]) state <= 4'b0100; // Then to device 1
                else if (r[2]) state <= 4'b1000; // Lowest priority to device 2
                else state <= 4'b0001; // Stay in A if no requests
            end
            state[1]: begin // State B (device 0 granted)
                state <= r[0] ? 4'b0010 : 4'b0001;
            end
            state[2]: begin // State C (device 1 granted)
                state <= r[1] ? 4'b0100 : 4'b0001;
            end
            state[3]: begin // State D (device 2 granted)
                state <= r[2] ? 4'b1000 : 4'b0001;
            end
            default: state <= 4'b0001; // Default to state A
        endcase
    end
end

// Direct assignments for output signals g based on the current state
assign g[0] = state[1]; // Device 0 granted in state B
assign g[1] = state[2]; // Device 1 granted in state C
assign g[2] = state[3]; // Device 2 granted in state D

endmodule
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding (one-hot with explicit states):
    // 0001 - State A (idle)
    // 0010 - State B (g0)
    // 0100 - State C (g1)
    // 1000 - State D (g2)
    reg [3:0] state;

    // Clock gating suggestion (uncomment if power is critical)
    // wire fsm_clk = (state == 4'b0001) ? clk :  // Clock always on in idle state
    //               (state[1] && !r[0]) ? clk :  // Clock when g0 might release
    //               (state[2] && !r[1]) ? clk :  // Clock when g1 might release
    //               (state[3] && !r[2]) ? clk :  // Clock when g2 might release
    //               1'b0;                        // Gated otherwise

    always @(posedge clk /* or posedge fsm_clk if using clock gating */) begin
        if (!resetn) begin
            state <= 4'b0001; // Reset to state A
        end else begin
            case (state)
                4'b0001: begin // State A
                    if (r[0])       state <= 4'b0010; // Highest priority
                    else if (r[1])  state <= 4'b0100;
                    else if (r[2])  state <= 4'b1000;
                    else            state <= 4'b0001; // Stay in A
                end
                4'b0010: state <= r[0] ? 4'b0010 : 4'b0001; // State B (g0)
                4'b0100: state <= r[1] ? 4'b0100 : 4'b0001; // State C (g1)
                4'b1000: state <= r[2] ? 4'b1000 : 4'b0001; // State D (g2)
                default: state <= 4'b0001; // Handle undefined states
            endcase
        end
    end

    // Output mapping (direct from state bits)
    assign g[0] = state[1]; // g0 active in state B
    assign g[1] = state[2]; // g1 active in state C
    assign g[2] = state[3]; // g2 active in state D

endmodule
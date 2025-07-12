module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (A-F = bits 0-5)
    reg [5:0] state;

    // State transition logic using parallel bitwise operations
    always @(posedge clk) begin
        if (reset) begin
            state <= 6'b000001; // Reset to state A (bit 0)
        end else begin
            state <= {
                // State F (bit 5) transitions:
                (state[4] & w) | (state[5] & w),  // F->C when w=1
                
                // State E (bit 4) transitions:
                (state[4] & w) | (state[2] & w),  // E->E or C->E
                
                // State D (bit 3) transitions:
                (state[1] & ~w) | (state[2] & ~w) | (state[4] & ~w) | (state[5] & ~w), // B/C/E/F->D when w=0
                
                // State C (bit 2) transitions:
                (state[1] & w) | (state[5] & w),  // B/F->C when w=1
                
                // State B (bit 1) transitions:
                state[0] & w,                     // A->B when w=1
                
                // State A (bit 0) transitions:
                (state[0] & ~w) | (state[3] & ~w)  // A->A or D->A when w=0
            };
        end
    end

    // Output is directly bits 4 (E) or 5 (F) from state register
    assign z = state[4] | state[5];

endmodule
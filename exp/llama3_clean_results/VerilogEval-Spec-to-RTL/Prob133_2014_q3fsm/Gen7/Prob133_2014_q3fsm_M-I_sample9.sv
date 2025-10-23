module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 0;
localparam STATE_B = 1;

reg state; // Current state
reg [1:0] w_count; // Counter for w = 1
reg [1:0] cycle_count; // Counter for the three cycles

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        state <= STATE_A;
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                // Transition from state A to state B when s = 1
                if(s) begin
                    state <= STATE_B;
                    w_count <= 0;
                    cycle_count <= 1; // Initialize cycle_count to 1
                end
            end
            STATE_B: begin
                // Examine input w and increment w_count if w = 1
                if(w) begin
                    w_count <= w_count + 1;
                end
                // Increment cycle_count
                cycle_count <= cycle_count + 1;
                // Check if three cycles have passed
                if(cycle_count == 4) begin
                    // Set output z based on w_count
                    if(w_count == 2) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    // Reset w_count and cycle_count
                    w_count <= 0;
                    cycle_count <= 0;
                    // Transition back to state A
                    if(~s) begin
                        state <= STATE_A;
                    end
                end
                // If we're still in state B and s is low, reset z
                else if(~s) begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule
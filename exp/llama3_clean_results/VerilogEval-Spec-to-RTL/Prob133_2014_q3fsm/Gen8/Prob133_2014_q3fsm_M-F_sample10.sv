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
reg set_z; // Flag to set z in the next cycle

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        state <= STATE_A;
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
        set_z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                // Transition from state A to state B when s = 1
                if(s) begin
                    state <= STATE_B;
                    w_count <= 0;
                    cycle_count <= 0; // Initialize cycle_count to 0
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
                if(cycle_count == 3) begin
                    // Set flag to set output z based on w_count
                    if(w_count == 2) begin
                        set_z <= 1;
                    end
                    else begin
                        set_z <= 0;
                    end
                    // Reset w_count and cycle_count
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
        endcase
        // Set z based on set_z flag and reset the flag
        if(set_z) begin
            z <= 1;
        end
        else begin
            z <= 0;
        end
        set_z <= 0;
    end
end

endmodule
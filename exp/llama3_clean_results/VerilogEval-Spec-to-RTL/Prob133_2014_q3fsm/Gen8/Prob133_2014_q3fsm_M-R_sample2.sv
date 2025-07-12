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

reg [1:0] state; // Current state (2 bits to allow for future expansion)
reg [1:0] w_count; // Counter for w = 1
reg [1:0] cycle_count; // Counter for the three cycles

// Sequential logic
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
                if(cycle_count == 3) begin
                    // Reset w_count and cycle_count
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
        endcase
    end
end

// Combinational logic for output z
always @(posedge clk) begin
    if(state == STATE_B && cycle_count == 3) begin
        // Set output z based on w_count
        if(w_count == 2) begin
            z <= 1;
        end
        else begin
            z <= 0;
        end
    end
    else begin
        z <= 0;
    end
end

endmodule
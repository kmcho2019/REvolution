module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 1'b0;
localparam STATE_B = 1'b1;

reg state; // Current state
reg [1:0] sub_state; // Sub-state for STATE_B
reg [1:0] count; // Counter for 'w' inputs
reg [1:0] cycle_count; // Counter for cycles

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        sub_state <= 2'b00;
        count <= 2'b0;
        cycle_count <= 2'b0;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    sub_state <= 2'b00;
                    count <= 2'b0;
                    cycle_count <= 2'b0;
                end
            end
            STATE_B: begin
                // Increment cycle counter
                cycle_count <= cycle_count + 1'b1;
                // Increment 'w' counter if 'w' is '1'
                if(w) begin
                    count <= count + 1'b1;
                end
                // Check if three cycles have passed
                if(cycle_count == 2'b11) begin
                    // Check if exactly two 'w' inputs are '1'
                    if(count == 2'b10) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    // Reset counters
                    cycle_count <= 2'b00;
                    count <= 2'b00;
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule
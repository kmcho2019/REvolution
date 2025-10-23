module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] cycle_count; // Counter for the three cycles
reg [1:0] w_count; // Counter for w = 1
reg in_b_state; // Flag to indicate if we are in state B
reg z_reg; // Register for output z

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        cycle_count <= 0;
        w_count <= 0;
        in_b_state <= 0;
        z_reg <= 0;
    end
    else begin
        if(!in_b_state) begin
            // Transition from state A to state B when s = 1
            if(s) begin
                in_b_state <= 1;
                cycle_count <= 1; // Initialize cycle_count to 1
                w_count <= 0;
            end
        end
        else begin
            // Examine input w and increment w_count if w = 1
            if(w) begin
                w_count <= w_count + 1;
            end
            // Increment cycle_count
            cycle_count <= cycle_count + 1;
            // Check if three cycles have passed
            if(cycle_count == 3) begin
                in_b_state <= 1;
                cycle_count <= 1; // Reset cycle_count
                w_count <= 0;
            end
        end
    end
end

assign z = (cycle_count == 1 && w_count == 2) ? 1 : 0;

endmodule
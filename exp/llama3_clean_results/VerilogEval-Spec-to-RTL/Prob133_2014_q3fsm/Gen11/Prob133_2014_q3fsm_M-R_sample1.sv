module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg state; // State variable: 0 for state A, 1 for state B
reg [1:0] w_count; // Counter for w = 1
reg [1:0] cycle_count; // Counter for the three cycles
reg z_reg; // Register for output z

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        state <= 0;
        w_count <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end
    else begin
        if(!state) begin
            // Transition from state A to state B when s = 1
            if(s) begin
                state <= 1;
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
                cycle_count <= 1; // Reset cycle_count
                w_count <= 0;
            end
        end
    end
end

always @(posedge clk) begin
    if(reset) begin
        z_reg <= 0;
    end
    else if(state && cycle_count == 1) begin
        // Set z_reg based on w_count
        if(w_count == 2) begin
            z_reg <= 1;
        end
        else begin
            z_reg <= 0;
        end
    end
    else begin
        z_reg <= 0;
    end
end

assign z = z_reg;

endmodule
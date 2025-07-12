module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] cycle_count; // Counter for the three cycles
reg [1:0] w_count; // Counter for w = 1
reg set_z; // Flag to set z in the next cycle

always @(posedge clk) begin
    if(reset) begin
        cycle_count <= 0;
        w_count <= 0;
        set_z <= 0;
        z <= 0;
    end
    else begin
        // Check if s = 1 to start the cycle
        if(s && cycle_count == 0) begin
            cycle_count <= 1;
            w_count <= 0;
        end
        // Increment cycle_count and check w
        else if(cycle_count < 3) begin
            cycle_count <= cycle_count + 1;
            if(w) begin
                w_count <= w_count + 1;
            end
        end
        // Check if three cycles have passed
        else if(cycle_count == 3) begin
            // Check if w_count is 2
            if(w_count == 2) begin
                set_z <= 1;
            end
            cycle_count <= 0;
            w_count <= 0;
        end
        // Set z based on the flag
        if(set_z) begin
            z <= 1;
            set_z <= 0;
        end
        else begin
            z <= 0;
        end
    end
end

endmodule
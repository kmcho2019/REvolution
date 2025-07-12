module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] w_shift_reg; // 3-bit shift register to store 'w' values
reg [1:0] cycle_count; // Counter for clock cycles since state transition
reg state; // Current state (A or B)

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        state <= 0; // State A
        w_shift_reg <= 0;
        cycle_count <= 0;
        z <= 0;
    end
    else begin
        if(!state) begin
            // State A
            if(s) begin
                state <= 1; // Transition to state B
                w_shift_reg <= 0;
                cycle_count <= 1;
            end
        end
        else begin
            // State B
            // Shift 'w' into the shift register
            w_shift_reg <= {w, w_shift_reg[2:1]};
            // Increment cycle count
            cycle_count <= cycle_count + 1;
            // Check if three cycles have passed
            if(cycle_count == 3) begin
                // Examine shift register contents
                if((w_shift_reg == 3'b001) || (w_shift_reg == 3'b010) || (w_shift_reg == 3'b100)) begin
                    z <= 1; // Set 'z' to 1
                end
                else begin
                    z <= 0; // Set 'z' to 0
                end
                // Reset cycle count and shift register
                cycle_count <= 1;
                w_shift_reg <= 0;
            end
            else if(cycle_count > 1) begin
                z <= 0; // Reset 'z' to 0
            end
        end
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] cycle_counter; // Counter for the 3 clock cycles in State B
reg w_count; // Count of w being high in the current 3-cycle window
reg z_next; // Next value of z, to be assigned in the following clock cycle

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to State A
        cycle_counter <= 0;
        w_count <= 0;
        z_next <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to State B
                end
            end
            1: begin // State B
                if(cycle_counter == 0) begin
                    w_count <= 0; // Reset w_count at the start of each 3-cycle window
                end
                if(w) begin
                    w_count <= w_count + 1; // Increment w_count if w is high
                end
                cycle_counter <= cycle_counter + 1; // Increment cycle counter
                if(cycle_counter == 2) begin // At the end of the 3-cycle window
                    z_next <= (w_count == 2); // Set z_next based on w_count
                end
                if(cycle_counter == 3) begin // After the decision cycle
                    cycle_counter <= 0; // Reset cycle_counter
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    z <= z_next; // Update z on the next clock cycle after decision
end

endmodule
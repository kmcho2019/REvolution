module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// State variable (2 states: A and B)
reg [1:0] state;
reg [1:0] state_next;

// Counter for three clock cycles
reg [1:0] cycle_count;
reg [1:0] cycle_count_next;

// Counter for w = 1 occurrences
reg [1:0] w_count;
reg [1:0] w_count_next;

// Output z
reg z_reg;
reg z_next;

// Initial state
initial state = 2'b00; // State A

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        cycle_count <= 2'b00;
        w_count <= 2'b00;
        z_reg <= 1'b0;
    end else begin
        state <= state_next;
        cycle_count <= cycle_count_next;
        w_count <= w_count_next;
        z_reg <= z_next;
    end
end

always @(*) begin
    state_next = state;
    cycle_count_next = cycle_count;
    w_count_next = w_count;
    z_next = z_reg;

    case (state)
        2'b00: begin // State A
            if (s) begin
                state_next = 2'b01; // Move to state B
                cycle_count_next = 2'b01; // Start counting cycles
                w_count_next = 2'b00; // Reset w count
            end
        end
        2'b01: begin // State B
            // Increment cycle count
            cycle_count_next = cycle_count + 1'b1;

            // Count w = 1 occurrences
            if (w) begin
                w_count_next = w_count + 1'b1;
            end

            // Check if we've completed three cycles
            if (cycle_count == 2'b11) begin
                // Set z based on w count
                if (w_count == 2'b10) begin
                    z_next = 1'b1;
                end else begin
                    z_next = 1'b0;
                end

                // Reset for next three cycles
                cycle_count_next = 2'b00;
                w_count_next = 2'b00;
            end
        end
    endcase
end

assign z = z_reg;

endmodule
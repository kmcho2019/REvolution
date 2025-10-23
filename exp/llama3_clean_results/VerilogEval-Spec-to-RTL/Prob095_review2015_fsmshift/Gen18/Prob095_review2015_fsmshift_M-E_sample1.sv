module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // State variable to track the current state (IDLE or SHIFT_ENABLE)
    logic [0:0] state;

    // Counter to count the clock cycles in the SHIFT_ENABLE state
    logic [1:0] counter;

    // Signal to track whether we are in the first clock cycle of SHIFT_ENABLE
    logic first_cycle;

    always_ff @(posedge clk) begin
        if (reset) begin
            // Transition to SHIFT_ENABLE state and initialize counter
            state <= 1'b1;
            counter <= 2'd0; // Initialize counter to 0
            first_cycle <= 1'b1; // Set first_cycle to 1
        end else if (state == 1'b1) begin
            // Increment counter in SHIFT_ENABLE state
            counter <= counter + 1;

            // If counter reaches 4, transition back to IDLE state
            if (counter == 4'd3) begin
                state <= 1'b0;
                first_cycle <= 1'b0; // Reset first_cycle
            end
        end
    end

    // Assert shift_ena when in SHIFT_ENABLE state
    assign shift_ena = (state == 1'b1);

endmodule
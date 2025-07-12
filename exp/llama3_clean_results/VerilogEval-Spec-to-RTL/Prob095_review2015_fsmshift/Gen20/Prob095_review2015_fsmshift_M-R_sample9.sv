module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // State machine: active (1) or inactive (0)
    logic state;

    // Counter to track cycles during reset
    logic [1:0] counter;

    // Sequential logic for state machine and counter
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 1'b1; // Reset to active state
            counter <= 2'b00; // Reset counter to 0
        end else if (state == 1'b1) begin
            counter <= counter + 1'b1; // Increment counter in active state
            if (counter == 4) begin
                state <= 1'b0; // Transition to inactive state after 4 cycles
            end
        end
    end

    // Combinational logic for shift_ena
    assign shift_ena = state; // Assert shift_ena when in active state

endmodule
module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Define a 2-bit state variable to keep track of the cycles
    logic [1:0] state;

    // Initialize state to 0
    initial state = 0;

    // This always block is triggered on the positive edge of the clock
    always_ff @(posedge clk) begin
        if (reset) begin
            // If reset is high, initialize the state to 4 - 1 (to account for 0-based indexing)
            state <= 4 - 1;
        end else if (state > 0) begin
            // Decrement the state on each clock cycle until it reaches 0
            state <= state - 1;
        end
    end

    // Assert shift_ena as long as the state is greater than 0
    assign shift_ena = (state > 0);

endmodule
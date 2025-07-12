module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Initialize a 2-bit counter to keep track of the number of cycles
    logic [1:0] counter;

    // This always block is triggered on the positive edge of the clock
    always_ff @(posedge clk) begin
        // If reset is high, initialize the counter to 4 (which is 100 in binary for a 2-bit counter)
        if (reset) begin
            counter <= 4 - 1; // We subtract 1 because we're using 0 to 3 to represent 4 cycles
        end else if (counter > 0) begin
            // Decrement the counter on each clock cycle until it reaches 0
            counter <= counter - 1;
        end
    end

    // Assert shift_ena as long as the counter is greater than 0
    assign shift_ena = (counter > 0);

endmodule
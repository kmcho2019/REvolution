module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    // Thermometer-coded states: 00, 01, 11, 10
    reg [1:0] counter;

    // Next state computation (all possibilities in parallel)
    wire [1:0] next_inc = {counter[1] | counter[0], counter[1] & counter[0]}; // Thermometer increment
    wire [1:0] next_dec = {counter[1] & counter[0], counter[1] | counter[0]}; // Thermometer decrement
    wire [1:0] next_hold = counter;

    // Select appropriate next state
    wire [1:0] next_counter;
    assign next_counter = areset ? 2'b01 :                // Reset to weakly not-taken
                       train_valid ? 
                           (train_taken ? next_inc :     // Increment if taken
                                       next_dec) :       // Decrement if not taken
                       next_hold;                        // Hold when not training

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;
        end else begin
            counter <= next_counter;
        end
    end

    assign state = counter;

endmodule
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire enable;
    wire [9:0] next_counter;

    // Enable signal: update counter only if loading or counting down (not zero)
    assign enable = load | (counter != 0);

    // Next counter value computed only if enabled; else retain current
    assign next_counter = load ? data :
                          (counter - 1);

    // Sequential logic: update counter only when enabled
    always @(posedge clk) begin
        if (enable)
            counter <= next_counter;
        else
            counter <= counter; // explicit retain for clarity, synthesizer will optimize
    end

    // Terminal count asserted when counter reaches zero
    assign tc = (counter == 0);

endmodule
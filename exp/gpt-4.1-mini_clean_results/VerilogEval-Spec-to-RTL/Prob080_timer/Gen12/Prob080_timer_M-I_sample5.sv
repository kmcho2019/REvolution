module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_enable;

    // Determine if counter should update: load or counter nonzero
    assign counter_enable = load | (|counter);

    // Compute next counter value
    assign next_counter = load ? data :
                          (|counter ? counter - 10'd1 : 10'd0);

    // Update counter only if enabled to reduce switching
    always @(posedge clk) begin
        if (counter_enable)
            counter <= next_counter;
    end

    // Terminal count signal: asserted when counter reaches zero
    assign tc = ~|counter;

endmodule
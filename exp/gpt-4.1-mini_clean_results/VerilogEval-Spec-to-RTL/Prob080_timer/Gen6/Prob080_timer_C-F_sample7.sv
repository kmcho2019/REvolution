module TopModule(
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire       counter_enable;

    // Compute next counter value combinationally
    assign next_counter = load ? data :
                          (counter != 10'd0 ? counter - 10'd1 : 10'd0);

    // Enable updating counter only when loading or counting down
    assign counter_enable = load | (counter != 10'd0);

    // Sequential logic: update counter only when enabled
    always @(posedge clk) begin
        if (counter_enable) begin
            counter <= next_counter;
        end
        // else retain previous counter value (holds at zero)
    end

    // Terminal count is asserted when counter is zero
    assign tc = (counter == 10'd0);

endmodule
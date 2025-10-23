module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] counter_dec;
    wire [9:0] next_counter;
    wire counter_en;

    // Calculate decremented counter (when counter != 0)
    assign counter_dec = (counter != 0) ? (counter - 1) : 10'd0;

    // Next counter value: load data if load is asserted, else decrement
    assign next_counter = load ? data : counter_dec;

    // Enable register update only when loading or counting down
    assign counter_en = load | (counter != 0);

    always @(posedge clk) begin
        if (counter_en)
            counter <= next_counter;
    end

    // Terminal count asserted when counter reaches zero
    assign tc = (counter == 0);

endmodule
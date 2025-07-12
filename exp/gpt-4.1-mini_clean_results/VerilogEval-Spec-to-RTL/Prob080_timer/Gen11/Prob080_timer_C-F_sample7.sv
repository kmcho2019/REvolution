module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire update_en;

    // Compute next counter value
    assign next_counter = load ? data :
                          (|counter ? counter - 10'd1 : counter);

    // Enable register update only when counter changes (load or decrement)
    assign update_en = load | (counter != 10'd0);

    always @(posedge clk) begin
        if (update_en)
            counter <= next_counter;
        // else retain current counter value (no update)
    end

    // Terminal count signal asserted when counter reaches zero
    assign tc = ~|counter;

endmodule
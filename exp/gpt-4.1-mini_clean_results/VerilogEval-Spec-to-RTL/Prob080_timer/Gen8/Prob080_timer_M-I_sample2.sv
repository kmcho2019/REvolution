module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire ce;  // clock enable

    // Determine clock enable: update counter only if loading or counter not zero
    assign ce = load | (|counter);

    // Combinational logic to compute next counter value
    assign next_counter = load ? data :
                          (|counter ? counter - 10'd1 : 10'd0);

    // Sequential register update with clock enable
    always @(posedge clk) begin
        if (ce)
            counter <= next_counter;
    end

    // Terminal count output: asserted when counter is zero
    assign tc = ~|counter;

endmodule
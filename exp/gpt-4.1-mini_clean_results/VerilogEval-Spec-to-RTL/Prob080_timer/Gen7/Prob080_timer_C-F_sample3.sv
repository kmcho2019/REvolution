module TopModule(
    input        clk,
    input        load,
    input [9:0]  data,
    output       tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire       ce; // clock enable for register update

    // Next counter value logic:
    // If load=1, load input data.
    // Else if counter != 0, decrement.
    // Else hold zero.
    assign next_counter = load ? data :
                          (counter != 10'd0) ? (counter - 1) :
                          10'd0;

    // Enable update only if counter changes (load=1 or counter !=0)
    assign ce = load | (counter != 10'd0);

    always @(posedge clk) begin
        if (ce)
            counter <= next_counter;
        // else retain previous counter value to reduce unnecessary toggling
    end

    // Terminal count output asserted when counter reaches zero
    assign tc = (counter == 10'd0);

endmodule
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Compute next counter value combinationally:
    // - If load is asserted, load the new data.
    // - Else, if counter is nonzero, decrement by one.
    // - Otherwise, hold at zero.
    assign next_counter = load ? data :
                          (counter != 0) ? (counter - 1) :
                          10'd0;

    // Sequential update of counter on positive clock edge
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output asserted when counter reaches zero
    assign tc = (counter == 0);

endmodule
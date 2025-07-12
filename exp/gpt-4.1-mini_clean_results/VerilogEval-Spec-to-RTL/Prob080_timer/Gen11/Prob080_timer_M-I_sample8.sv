module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire count_enable;
    wire [9:0] next_counter;

    // Enable counting only when not loading and counter not zero
    assign count_enable = ~load & (counter != 0);

    // Compute next counter value:
    // - Load new data if load is asserted.
    // - Else decrement if enabled.
    // - Else hold current value (counter is zero).
    assign next_counter = load ? data :
                          count_enable ? (counter - 1) :
                          counter;

    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count output asserted when counter reaches zero
    assign tc = (counter == 0);

endmodule
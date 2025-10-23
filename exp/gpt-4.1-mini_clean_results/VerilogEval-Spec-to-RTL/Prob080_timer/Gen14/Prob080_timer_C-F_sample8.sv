module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Compute next counter value: if load is asserted, load data;
    // else decrement only if counter is not zero, else stay at zero.
    assign next_counter = load ? data :
                          (counter != 0 ? counter - 1 : 0);

    // Sequential logic: update counter on positive clock edge
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count asserted when counter reaches zero
    assign tc = (counter == 0);

endmodule
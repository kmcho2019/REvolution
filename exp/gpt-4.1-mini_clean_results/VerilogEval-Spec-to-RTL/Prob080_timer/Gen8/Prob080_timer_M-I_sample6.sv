module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_nonzero = (|counter);      // counter > 0
    wire ce = load | counter_nonzero;       // clock enable

    // Compute next counter value
    wire [9:0] next_counter = load ? data :
                             (counter_nonzero ? counter - 10'd1 : counter);

    always @(posedge clk) begin
        if (ce) begin
            counter <= next_counter;
        end
        // else hold previous value
    end

    assign tc = ~(|counter);  // tc asserted when counter == 0

endmodule
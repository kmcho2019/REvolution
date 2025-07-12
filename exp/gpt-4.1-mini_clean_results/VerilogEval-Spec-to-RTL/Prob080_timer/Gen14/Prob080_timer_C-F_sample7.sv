module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;

    // Next counter value logic:
    // - If load is asserted, load the input data.
    // - Else if counter is not zero, decrement by 1.
    // - Else hold at zero.
    assign next_counter = load ? data :
                          (counter != 0 ? counter - 1 : 0);

    // Single clocked process to update the counter register
    always @(posedge clk) begin
        counter <= next_counter;
    end

    // Terminal count asserted when counter reaches zero
    assign tc = (counter == 0);

endmodule
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire enable;

    // Combinational logic to compute next counter value
    assign next_counter = load ? data :
                          (counter != 0 ? counter - 10'd1 : 10'd0);

    // Enable update only when loading or counting down
    assign enable = load | (counter != 0);

    // Update counter on clock edge only if enabled
    always @(posedge clk) begin
        if (enable)
            counter <= next_counter;
    end

    // Terminal count signal asserted when counter is zero
    assign tc = (counter == 10'd0);

endmodule
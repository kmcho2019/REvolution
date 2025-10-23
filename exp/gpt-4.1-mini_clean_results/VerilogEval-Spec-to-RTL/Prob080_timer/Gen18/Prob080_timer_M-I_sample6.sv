module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire count_enable;
    wire [9:0] next_counter;

    // Enable updating counter only when loading or counting down
    assign count_enable = load | (counter != 0);

    // Compute next counter value only if enabled; else hold current value
    assign next_counter = load ? data :
                          (counter != 0 ? counter - 1 : counter);

    always @(posedge clk) begin
        if (count_enable)
            counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule
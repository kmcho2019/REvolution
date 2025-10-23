module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire count_enable;    // Enable signal for updating the counter
    wire [9:0] next_counter;

    // Enable counter update only when loading or counting down (counter>0)
    assign count_enable = load | (counter != 0);

    // Compute next counter value
    assign next_counter = load ? data :
                          (counter - 1);

    always @(posedge clk) begin
        if (count_enable) 
            counter <= next_counter;
    end

    assign tc = (counter == 0);

endmodule
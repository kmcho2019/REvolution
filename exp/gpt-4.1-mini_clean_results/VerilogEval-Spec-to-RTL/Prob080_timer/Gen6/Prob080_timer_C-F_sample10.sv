module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire enable;
    wire [9:0] next_counter;

    // Enable counting only when loading or counting down (counter != 0)
    assign enable = load | (counter != 10'b0);

    // Compute next counter value based on load and counting down
    assign next_counter = load ? data :
                          (counter != 10'b0 ? counter - 1 : 10'b0);

    always @(posedge clk) begin
        if (enable) begin
            counter <= next_counter;
        end
        // else retain the counter value (no toggle)
    end

    assign tc = (counter == 10'b0);

endmodule
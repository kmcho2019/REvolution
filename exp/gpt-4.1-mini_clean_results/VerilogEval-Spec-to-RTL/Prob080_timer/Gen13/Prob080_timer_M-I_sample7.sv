module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire count_enable;

    // Compute next counter value combinationally
    assign next_counter = load ? data :
                          (counter != 0) ? (counter - 1) :
                          10'd0;

    // Enable register update only when loading or counting down
    assign count_enable = load | (counter != 0);

    // Update counter at positive clock edge with enable
    always @(posedge clk) begin
        if (count_enable) begin
            counter <= next_counter;
        end
    end

    // Terminal count when counter reaches zero
    assign tc = (counter == 0);

endmodule
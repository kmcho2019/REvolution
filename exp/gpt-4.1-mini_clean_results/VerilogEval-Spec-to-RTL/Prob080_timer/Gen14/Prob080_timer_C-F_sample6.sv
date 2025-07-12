module TopModule(
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire       enable;

    // Compute next counter value combinationally
    assign next_counter = load ? data :
                          (counter != 0) ? (counter - 1) :
                          10'd0;

    // Enable counter update only when loading or counting down
    assign enable = load | (counter != 0);

    // Sequential update of the counter register with enable gating
    always @(posedge clk) begin
        if (enable)
            counter <= next_counter;
    end

    // Terminal count when counter reaches zero
    assign tc = (counter == 0);

endmodule
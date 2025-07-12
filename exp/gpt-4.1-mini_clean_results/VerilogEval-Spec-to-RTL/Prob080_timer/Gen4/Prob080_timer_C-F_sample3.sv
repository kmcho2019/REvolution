module TopModule(
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);

    reg [9:0] counter;
    reg [9:0] next_counter;
    wire      enable;

    // Determine when to update the counter register
    // Only update when loading or counting down (counter != 0 and not loading)
    assign enable = load | ((counter != 10'b0) & ~load);

    // Combinational logic to compute next counter value
    always @(*) begin
        if (load) begin
            next_counter = data;
        end else if (counter != 10'b0) begin
            next_counter = counter - 1;
        end else begin
            next_counter = 10'b0;
        end
    end

    // Sequential logic to update counter on clock edge with enable gating
    always @(posedge clk) begin
        if (enable)
            counter <= next_counter;
        // else retain the current value (counter holds)
    end

    // Terminal count output is asserted when counter reaches zero
    assign tc = (counter == 10'b0);

endmodule
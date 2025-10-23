module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;

    // Clock enable: active when load asserted or counter not zero (counting down)
    wire cen = load | (counter != 10'b0);

    // Next value logic (combinational)
    wire [9:0] next_counter = load ? data :
                             (counter - 1);

    // Sequential update with clock enable
    always @(posedge clk) begin
        if (cen)
            counter <= next_counter;
        // else retain current counter (no toggling)
    end

    // Terminal count output when counter is zero
    assign tc = (counter == 10'b0);

endmodule
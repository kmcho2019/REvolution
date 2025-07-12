module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire [9:0] counter_next;
wire count_enable;

assign counter_next = (counter != 0) ? (counter - 1) : 0;

// Enable counting only when load is asserted or counter is not zero (counting)
assign count_enable = load | (counter != 0);

always @(posedge clk) begin
    if (count_enable) begin
        if (load)
            counter <= data;
        else
            counter <= counter_next;
    end
    // else hold the counter value to reduce toggling
end

assign tc = (counter == 0);

endmodule
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire counter_enable;
wire [9:0] decremented;

// Enable update if loading or counter not zero (counting down)
assign counter_enable = load | (counter != 0);

// Decrement by 1 using simple ripple logic
assign decremented = counter - 10'd1;

always @(posedge clk) begin
    if (counter_enable) begin
        if (load)
            counter <= data;
        else
            counter <= decremented;
    end
    // else hold current counter value (no change)
end

assign tc = (counter == 0);

endmodule
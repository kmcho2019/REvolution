module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire count_enable;
wire [9:0] counter_next;

// Enable counting only when counter is not zero and load is not asserted
assign count_enable = (counter != 0) && (~load);

// Compute next counter value: decrement by 1 if enabled, else stay same
assign counter_next = count_enable ? (counter - 1) : counter;

always @(posedge clk) begin
    if (load)
        counter <= data;
    else
        counter <= counter_next;
end

assign tc = (counter == 0);

endmodule
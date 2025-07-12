module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire enable;
wire [9:0] counter_next;

assign enable = (counter != 0) && (load == 0);
assign counter_next = enable ? (counter - 1) : counter;

always @(posedge clk) begin
    if (load)
        counter <= data;
    else if (enable)
        counter <= counter_next;
    // else hold current counter value (no change)
end

assign tc = (counter == 0);

endmodule
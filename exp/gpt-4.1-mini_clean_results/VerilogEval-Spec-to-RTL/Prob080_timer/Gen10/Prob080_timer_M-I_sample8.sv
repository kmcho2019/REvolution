module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire ce; // clock enable for counting down
wire [9:0] counter_next;

assign ce = (~load) & (counter != 0);
assign counter_next = counter - 1;

always @(posedge clk) begin
    if (load)
        counter <= data;
    else if (ce)
        counter <= counter_next;
    // else hold current counter value
end

assign tc = (counter == 0);

endmodule
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire [9:0] counter_next;

assign counter_next = (counter != 0) ? (counter - 1) : 0;

always @(posedge clk) begin
    if (load)
        counter <= data;
    else
        counter <= counter_next;
end

assign tc = (counter == 0);

endmodule
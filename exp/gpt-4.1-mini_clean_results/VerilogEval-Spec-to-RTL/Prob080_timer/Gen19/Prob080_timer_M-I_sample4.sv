module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

reg [9:0] counter;
wire enable;
wire [9:0] counter_next;

assign enable = load | (counter != 0);
assign counter_next = (counter != 0) ? (counter - 1) : 0;

always @(posedge clk) begin
    if (enable) begin
        if (load)
            counter <= data;
        else
            counter <= counter_next;
    end
end

always @(posedge clk) begin
    tc <= (counter == 0);
end

endmodule
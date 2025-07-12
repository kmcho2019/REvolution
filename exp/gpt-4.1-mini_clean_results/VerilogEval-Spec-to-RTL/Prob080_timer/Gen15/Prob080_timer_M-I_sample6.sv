module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire [9:0] decremented = counter - 10'd1;
wire update_en = load | (counter != 10'd0);
wire [9:0] next_count = load ? data : (counter != 10'd0 ? decremented : counter);

always @(posedge clk) begin
    if (update_en)
        counter <= next_count;
end

assign tc = (counter == 10'd0);

endmodule
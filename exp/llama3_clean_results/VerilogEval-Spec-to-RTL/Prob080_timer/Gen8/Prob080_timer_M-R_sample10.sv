module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
assign tc = (counter == 10'd0);

always @(posedge clk) begin
    if (load) begin
        counter <= data;
    end else begin
        counter <= (counter == 10'd0) ? 10'd0 : counter - 1;
    end
end

endmodule
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
assign tc = (counter == 0)? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
    end else begin
        counter <= (counter == 0)? counter : counter - 1;
    end
end

endmodule
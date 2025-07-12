module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count; // 10-bit register to store the current count
assign tc = (count == 10'd0); // assert tc when count reaches 0

always @(posedge clk) begin
    if (load) begin // load the counter with data when load is high
        count <= data;
    end else if (count > 10'd0) begin // decrement the counter when load is low and count is not 0
        count <= count - 1;
    end
end

endmodule
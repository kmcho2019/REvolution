module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter; // internal 10-bit counter
assign tc = (counter == 10'd0) ? 1'b1 : 1'b0; // assert tc when counter reaches 0

always @(posedge clk) begin
    if (load) begin // load the counter with data when load is high
        counter <= data;
    end else if (counter != 10'd0) begin // decrement the counter when load is low
        counter <= counter - 1;
    end
end

endmodule
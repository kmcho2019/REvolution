module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter; // 10-bit register to store the current count
assign tc = (counter == 0) ? 1'b1 : 1'b0; // assert tc when counter reaches 0

always @(posedge clk) begin
    if (load) begin
        counter <= data; // load counter with data when load is high
    end else if (counter > 0) begin
        counter <= counter - 1; // decrement counter when load is low
    end
end

endmodule
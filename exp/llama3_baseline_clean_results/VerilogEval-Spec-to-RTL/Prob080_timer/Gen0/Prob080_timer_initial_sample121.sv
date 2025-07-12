module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;  // 10-bit register to store the counter value
assign tc = (counter == 0)? 1'b1 : 1'b0;  // assert tc when counter reaches 0

always @(posedge clk) begin
    if (load) begin
        // load the counter with the 10-bit data when load is 1
        counter <= data;
    end else if (counter > 0) begin
        // decrement the counter by 1 when load is 0 and counter is not 0
        counter <= counter - 1;
    end
end

endmodule
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count; // 10-bit register to store the count
assign tc = (count == 10'b0) ? 1'b1 : 1'b0; // assert tc when count reaches 0

always @(posedge clk) // sequential logic triggered on the positive edge of the clock
begin
    if (load) // load the counter with the 10-bit data
    begin
        count <= data;
    end
    else if (count != 10'b0) // decrement the counter by 1
    begin
        count <= count - 1'b1;
    end
    // else do nothing, keep the count at 0
end

endmodule
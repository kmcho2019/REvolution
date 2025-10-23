module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire enable;

assign enable = ~load & (counter != 0);

always @(posedge clk) begin
    if (load)
        counter <= data;
    else if (enable)
        counter <= counter - 1;
    // else retain current value (counter == 0)
end

assign tc = (counter == 0);

endmodule
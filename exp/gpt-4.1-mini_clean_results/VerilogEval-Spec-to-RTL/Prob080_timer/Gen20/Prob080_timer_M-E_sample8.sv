module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;

always @(posedge clk) begin
    if (load)
        counter <= data + 1;
    else if (counter != 0)
        counter <= counter - 1;
    else
        counter <= 0;
end

assign tc = (counter == 0);

endmodule
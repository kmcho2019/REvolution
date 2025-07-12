module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
wire decrement_enable;

assign decrement_enable = (~load) & (counter != 0);
assign tc = (counter == 0);

always @(posedge clk) begin
    if (load) begin
        counter <= data;
    end else if (decrement_enable) begin
        counter <= counter - 1;
    end
    // else hold counter at current value (including zero)
end

endmodule
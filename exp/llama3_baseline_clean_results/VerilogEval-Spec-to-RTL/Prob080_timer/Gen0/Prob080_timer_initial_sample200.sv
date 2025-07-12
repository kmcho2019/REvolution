module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
        tc <= 1'b0; // Reset tc when loading new value
    end else if (counter > 10'd0) begin
        counter <= counter - 1;
        tc <= 1'b0;
    end else begin
        tc <= 1'b1; // Assert tc when counter reaches 0
    end
end

endmodule
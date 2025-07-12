module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

reg [9:0] counter;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
        tc <= 1'b0; // Reset tc when loading a new value
    end else if (counter != 10'd0) begin
        counter <= counter - 1;
    end
    if (counter == 10'd0) begin
        tc <= 1'b1; // Assert tc when counter reaches 0
    end
end

endmodule
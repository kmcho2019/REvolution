module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;

always @(posedge clk) begin
    if (load) begin
        counter <= data; // Load the counter with the data when load is high
        tc <= 0; // Reset the terminal count when loading the counter
    end else if (counter > 0) begin
        counter <= counter - 1; // Decrement the counter by 1 when load is low and counter is not zero
    end
    // If the counter is already zero, do nothing, it stays zero
end

assign tc = (counter == 0) ? 1'b1 : 1'b0; // Assert tc when the counter reaches zero

endmodule
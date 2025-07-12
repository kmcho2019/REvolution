module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

// Initialize a 10-bit register to store the count
reg [9:0] count;

// Always block to handle the counter logic on the positive edge of the clock
always @(posedge clk) begin
    // Use a clear and concise logic with synchronous reset
    count <= (reset) ? 10'd0 : (count == 10'd999) ? 10'd0 : count + 10'd1;
end

// Assign the count to the output q
assign q = count;

endmodule
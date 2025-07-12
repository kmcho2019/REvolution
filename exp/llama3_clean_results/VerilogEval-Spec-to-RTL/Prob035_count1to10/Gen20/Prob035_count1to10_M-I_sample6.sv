module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

// Sequential logic to update the counter
always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset to 1
    end else begin
        count <= (count == 4'd10) ? 4'd1 : count + 1; // Increment or wrap around
    end
end

assign q = count;

endmodule
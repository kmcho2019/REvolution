module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 1; // Initialize count to 1

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 1
        count <= 1;
    end else begin
        // Normal counting operation
        if (count == 10) begin
            // Wrap around to 1 after reaching 10
            count <= 1;
        end else begin
            // Increment count
            count <= count + 1;
        end
    end
end

// Directly assign count to output q
assign q = count;

endmodule
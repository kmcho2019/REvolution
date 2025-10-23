module TopModule(
    input       clk,
    input       reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0; // Reset count to 0
    end else if (count == 4'd15) begin
        count <= 4'd0; // Wrap around to 0 after reaching 15
    end else begin
        count <= count + 1; // Increment count
    end
end

assign q = count; // Output the current count

endmodule
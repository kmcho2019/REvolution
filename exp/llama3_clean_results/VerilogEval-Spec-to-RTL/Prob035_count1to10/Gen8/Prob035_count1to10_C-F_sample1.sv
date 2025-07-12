module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 1; // Initialize count to 1 as per requirement

always @(posedge clk) begin
    if (reset || count == 4'd10) count <= 4'd1; // Direct comparison and reset
    else count <= count + 1; // Increment if not resetting or at max count
end

assign q = count; // Output the current count

endmodule
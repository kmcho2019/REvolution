module TopModule(
    input  clk,
    input  reset,
    input  slowena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000; // Reset counter to 0
    end else if (slowena && count < 4'd9) begin
        count <= count + 1; // Increment counter if slowena is high
    end else if (slowena && count == 4'd9) begin
        count <= 4'b0000; // Reset counter to 0 after reaching 9
    end
end

assign q = count; // Assign count to output q

endmodule
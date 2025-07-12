module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;  // Synchronous reset clears all bits
    end
    else begin
        q <= d;     // On clock edge, pass input to output
    end
end

endmodule
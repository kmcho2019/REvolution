module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;  // Reset all bits simultaneously
    end
    else begin
        q <= d;     // Capture all bits on clock edge
    end
end

endmodule
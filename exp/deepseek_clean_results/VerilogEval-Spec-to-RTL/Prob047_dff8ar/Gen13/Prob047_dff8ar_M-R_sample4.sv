module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;  // Reset all 8 bits simultaneously
    end
    else begin
        q <= d;     // Update all 8 bits on clock edge
    end
end

endmodule
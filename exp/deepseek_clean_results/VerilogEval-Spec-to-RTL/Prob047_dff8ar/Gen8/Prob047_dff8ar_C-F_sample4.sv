module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 0;  // Clear and concise asynchronous reset
    end
    else begin
        q <= d;   // Positive edge-triggered behavior
    end
end

endmodule
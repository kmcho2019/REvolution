module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output reg [7:0] q
);

// Synchronize asynchronous reset deassertion to avoid metastability and glitches
reg areset_sync1, areset_sync2;

always @(posedge clk or posedge areset) begin
    if (areset)
        {areset_sync2, areset_sync1} <= 2'b11;
    else begin
        areset_sync1 <= 1'b0;
        areset_sync2 <= areset_sync1;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset_sync2)
        q <= 8'b0;
    else
        q <= d;
end

endmodule
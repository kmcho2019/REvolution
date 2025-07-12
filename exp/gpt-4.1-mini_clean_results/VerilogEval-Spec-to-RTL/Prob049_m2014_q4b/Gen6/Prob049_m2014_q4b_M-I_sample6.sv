module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Synchronize asynchronous reset to clk domain
reg ar_sync_0, ar_sync_1;

always @(posedge clk or negedge ar)
    if (!ar)
        {ar_sync_0, ar_sync_1} <= 2'b00;
    else begin
        ar_sync_0 <= 1'b1;
        ar_sync_1 <= ar_sync_0;
    end

// Use synchronized reset for q
always @(posedge clk) begin
    if (!ar_sync_1)
        q <= 1'b0;
    else
        q <= d;
end

endmodule
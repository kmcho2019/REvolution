module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;           // Synchronous reset to 1
    end
    else begin
        q <= (q[3] & q[1]) ? 4'b0001 : q + 1;  // Wrap at 10 or increment
    end
end

endmodule
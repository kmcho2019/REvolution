module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        q <= (q + 1) % 10;  // Automatically wraps from 9 to 0
    end
end

endmodule
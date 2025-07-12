module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)

always @(posedge clk) begin
    if (reset) begin
        q <= START;          // Synchronous reset to 1
    end
    else begin
        q <= (q[3] & q[1]) ? START : q + 1;  // Efficient wrap check and increment
    end
end

endmodule
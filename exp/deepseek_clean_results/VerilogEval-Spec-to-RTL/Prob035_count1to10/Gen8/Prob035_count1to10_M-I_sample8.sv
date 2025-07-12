module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

always @(posedge clk) begin
    if (reset) begin
        q <= START;         // Synchronous reset to 1
    end
    else begin
        if (q == END) begin
            q <= START;    // Wrap around to 1
        end
        else begin
            q <= q + 4'b0001; // Increment counter
        end
    end
end

endmodule
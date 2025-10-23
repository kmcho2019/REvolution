module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;          // Synchronous reset to 1
    end
    else if (q[3] & q[1]) begin  // Efficient check for 10 (8+2)
        q <= 4'b0001;           // Wrap around to 1
    end
    else begin
        q <= q + 1;            // Normal increment
    end
end

endmodule
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Reset to 1
    end
    else if (q[3] & q[1]) begin  // Detect 10 (1010)
        q <= 4'b0001;
    end
    else begin
        q <= q + 4'b0001;  // Increment
    end
end

endmodule
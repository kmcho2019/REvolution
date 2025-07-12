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
        // Rotate left and add pattern to maintain count sequence
        q <= {q[2:0], q[3]} ^ 4'b0001;
    end
end

endmodule
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg terminal_count;

// Pre-compute terminal count
always @(posedge clk) begin
    terminal_count <= (q == 10'd999);
end

// Sequential state update with optimized logic
always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end
    else if (terminal_count) begin
        q <= 10'b0;
    end
    else begin
        q <= q + 1'b1;
    end
end

endmodule
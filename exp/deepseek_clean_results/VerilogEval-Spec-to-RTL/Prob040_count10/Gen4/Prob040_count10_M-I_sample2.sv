module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg terminal_count;

always @(posedge clk) begin
    terminal_count <= (q == 4'b1001);  // Registered terminal count
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (terminal_count) begin
        q <= 4'b0000;
    end
    else begin
        q <= q + 1'b1;
    end
end

endmodule
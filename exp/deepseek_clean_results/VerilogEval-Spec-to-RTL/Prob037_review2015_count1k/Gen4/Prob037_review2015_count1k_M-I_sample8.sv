module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [9:0] q_next;
reg terminal_count;

// Terminal count detection (registered)
always @(posedge clk) begin
    if (reset)
        terminal_count <= 1'b0;
    else
        terminal_count <= (q == 10'd999);
end

// Combinational next-state logic
always @(*) begin
    if (terminal_count)
        q_next = 10'b0;
    else
        q_next = q + 1'b1;
end

// Sequential logic
always @(posedge clk) begin
    if (reset)
        q <= 10'b0;
    else
        q <= q_next;
end

endmodule
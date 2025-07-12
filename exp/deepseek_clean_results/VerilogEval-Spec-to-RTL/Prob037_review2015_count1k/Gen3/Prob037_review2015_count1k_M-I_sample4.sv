module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [9:0] q_next;
wire terminal_count;

// Combinational next-state logic
always @(*) begin
    if (q == 10'd999)
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
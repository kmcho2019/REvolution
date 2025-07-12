module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] next_q;
reg gated_clk;

// Clock gating logic
always @(*) begin
    gated_clk = clk & (shift_ena | count_ena);
end

// Shared adder for both operations
always @(*) begin
    if (shift_ena)
        next_q = {q[2:0], data};
    else if (count_ena)
        next_q = q - 1'b1;
    else
        next_q = q;
end

// Pipelined register update with gated clock
always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule
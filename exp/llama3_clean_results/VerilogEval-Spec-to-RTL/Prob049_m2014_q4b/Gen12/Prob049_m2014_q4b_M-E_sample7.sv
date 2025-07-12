module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg latch_enable;
reg q_next;

always @(*)
    if (ar) begin
        latch_enable = 1'b0;
        q_next = 1'b0;
    end else if (clk) begin
        latch_enable = 1'b1;
        q_next = d;
    end else begin
        latch_enable = 1'b0;
        q_next = q;
    end

always @(posedge clk or posedge ar)
    if (ar)
        q <= 1'b0;
    else if (latch_enable)
        q <= q_next;

endmodule
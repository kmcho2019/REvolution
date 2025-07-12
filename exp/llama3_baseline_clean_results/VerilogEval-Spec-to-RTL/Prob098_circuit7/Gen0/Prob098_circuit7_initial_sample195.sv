module TopModule(
    input clk,
    input a,
    output reg q
);

reg q_next;

always @(*) begin
    if (q == 1'b1 && a == 1'b1) begin
        q_next = 1'b0;
    end else if (q == 1'b0 && a == 1'b1) begin
        q_next = 1'b1;
    end else begin
        q_next = q;
    end
end

always @(posedge clk) begin
    if (q == 1'bx) begin
        q <= 1'b1; // Set q to 1 when the clock first rises
    end else begin
        q <= q_next;
    end
end

endmodule
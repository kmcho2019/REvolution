module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [3:0] q_next;

always @(*) begin
    if (slowena) begin
        if (q == 4'd9)
            q_next = 4'd0;
        else
            q_next = q + 4'd1;
    end else begin
        q_next = q;
    end
end

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= q_next;
end

endmodule
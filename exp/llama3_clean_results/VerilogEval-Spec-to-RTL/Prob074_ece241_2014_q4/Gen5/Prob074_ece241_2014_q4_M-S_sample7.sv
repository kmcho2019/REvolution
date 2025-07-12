module TopModule(
    input clk,
    input x,
    output z
);

reg q1, q2, q3;

assign z = ~(q1 | q2 | q3);

always @(posedge clk) begin
    if (!q1) begin
        q1 <= x;
    end else begin
        q1 <= x ^ q1;
    end
    
    if (!q2) begin
        q2 <= x;
    end else begin
        q2 <= x & ~q2;
    end
    
    if (!q3) begin
        q3 <= x;
    end else begin
        q3 <= x | ~q3;
    end
end

endmodule
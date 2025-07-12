module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (!a && b) begin
        state <= 1;
    end else if (a && b || a && !b) begin
        state <= 0;
    end else if (state && !a && !b) begin
        state <= 1;
    end else begin
        state <= state;
    end
end

always @(*) begin
    if (b || (state && !a)) begin
        q = 1;
    end else begin
        q = 0;
    end
end

endmodule
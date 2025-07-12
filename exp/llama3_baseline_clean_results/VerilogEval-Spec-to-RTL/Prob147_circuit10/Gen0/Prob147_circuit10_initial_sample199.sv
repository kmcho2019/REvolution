module TopModule(
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

always @ (posedge clk) begin
    state <= q;
end

always @ (*) begin
    if (a && b) begin
        q = 0;
    end else if (b && !state) begin
        q = 1;
    end else if (!b && a && state) begin
        q = 0;
    end else begin
        q = state;
    end
end

endmodule
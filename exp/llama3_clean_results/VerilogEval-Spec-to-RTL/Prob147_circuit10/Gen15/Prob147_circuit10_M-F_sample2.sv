module TopModule(
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a && b) state <= ~state;
    else if (!a && b) state <= 1;
    else state <= state;
end

always @(*) begin
    if (state || (!a && b)) q = 1;
    else q = 0;
end

initial begin
    state = 0;
    q = 0;
end

endmodule
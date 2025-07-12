module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output reg state
);

always @(posedge clk) begin
    if (~a && b) begin
        state <= 1;
    end else if (a && b) begin
        state <= 0;
    end
end

assign q = (~state && b) || (state && ~b);

endmodule
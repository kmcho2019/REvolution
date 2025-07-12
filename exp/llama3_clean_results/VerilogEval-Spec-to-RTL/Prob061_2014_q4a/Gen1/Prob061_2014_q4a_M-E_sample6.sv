module TopModule(
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

always_ff @(posedge clk) begin
    reg temp;
    temp = L ? R : w;
    Q <= E ? temp : Q;
end

endmodule
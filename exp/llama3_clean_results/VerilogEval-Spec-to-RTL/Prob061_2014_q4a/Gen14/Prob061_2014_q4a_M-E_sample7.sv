module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (E) begin
        Q <= w;
    end
end

always @(posedge L) begin
    Q <= R;
end

endmodule
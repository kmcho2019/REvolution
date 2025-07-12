module TopModule(
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

reg q;

always_ff @(posedge clk) begin
    if (L) begin
        q <= R;
    end else if (E) begin
        q <= w;
    end
end

assign Q = q;

endmodule
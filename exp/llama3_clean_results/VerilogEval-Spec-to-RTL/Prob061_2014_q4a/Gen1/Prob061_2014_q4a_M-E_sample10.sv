module TopModule(
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

reg current_Q;

always_ff @(posedge clk) begin
    if (L) begin
        current_Q <= R;
    end else if (E) begin
        current_Q <= w;
    end else begin
        current_Q <= current_Q;
    end
    Q <= current_Q;
end

endmodule
module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire enable = L || E;
wire next_Q;

always @(*) begin
    if (L)
        next_Q = R;
    else if (E)
        next_Q = w;
    else
        next_Q = Q;
end

always @(posedge clk) begin
    if (enable) begin
        Q <= next_Q;
    end
end

endmodule
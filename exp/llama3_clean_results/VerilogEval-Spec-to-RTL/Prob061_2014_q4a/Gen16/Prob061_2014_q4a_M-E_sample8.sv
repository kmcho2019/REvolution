module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg temp;

always @(posedge clk) begin
    // First multiplexer: select between w and Q based on E
    if (E) begin
        temp <= w;
    end else begin
        temp <= Q;
    end

    // Second multiplexer: select between temp and R based on L
    if (L) begin
        Q <= R;
    end else begin
        Q <= temp;
    end
end

endmodule
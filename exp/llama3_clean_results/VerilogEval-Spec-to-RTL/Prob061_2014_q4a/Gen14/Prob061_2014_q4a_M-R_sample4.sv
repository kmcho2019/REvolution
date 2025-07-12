module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin // Load R when L is high
        Q <= R;
    end else if (E) begin // Shift w when E is high and not loading
        Q <= w;
    end else begin // Hold Q when neither L nor E is high
        Q <= Q;
    end
end

endmodule
module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)
            Q <= R;           // Load value R when load asserted
        else if (E)
            Q <= w;           // Shift in w when enabled
        else
            Q <= Q;           // Hold current value
    end

endmodule
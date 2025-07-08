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
            Q <= R;          // Load R when L is asserted
        else if (E)
            Q <= w;          // Shift in w when E is asserted and L is not
        else
            Q <= Q;          // Hold current state otherwise
    end

endmodule
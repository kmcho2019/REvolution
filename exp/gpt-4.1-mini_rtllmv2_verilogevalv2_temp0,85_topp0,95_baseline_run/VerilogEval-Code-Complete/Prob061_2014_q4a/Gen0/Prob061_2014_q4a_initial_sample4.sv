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
            Q <= R;       // Load value R into flip-flop
        else if (E)
            Q <= w;       // Shift in value w if enabled and not loading
        else
            Q <= Q;       // Hold current value otherwise
    end
endmodule
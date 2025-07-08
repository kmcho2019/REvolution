module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L) begin
            Q <= R;          // Load R when L asserted
        end else if (E) begin
            Q <= w;          // Shift in w when enabled
        end // else hold current Q
    end

endmodule
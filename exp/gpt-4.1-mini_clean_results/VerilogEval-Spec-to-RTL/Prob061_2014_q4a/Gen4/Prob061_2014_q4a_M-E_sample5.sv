module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)
            Q <= R;        // Load priority: when L asserted, load R
        else if (E)
            Q <= w;        // Else if enabled, shift in w
        else
            Q <= Q;        // Otherwise hold current state
    end

endmodule
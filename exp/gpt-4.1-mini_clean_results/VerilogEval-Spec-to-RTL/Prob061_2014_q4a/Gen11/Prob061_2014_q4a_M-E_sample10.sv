module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)       // Highest priority: load R into Q
            Q <= R;
        else if (E)  // If load not active, shift in w when enabled
            Q <= w;
        else         // Otherwise hold current value
            Q <= Q;
    end

endmodule
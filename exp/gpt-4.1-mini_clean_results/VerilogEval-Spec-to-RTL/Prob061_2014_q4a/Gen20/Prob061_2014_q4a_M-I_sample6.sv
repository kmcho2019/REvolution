module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)         // load has highest priority
            Q <= R;
        else if (E)    // then shift enable
            Q <= w;
        // else do nothing, hold current state
    end

endmodule
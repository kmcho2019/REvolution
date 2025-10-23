module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)
            Q <= R;     // Load has highest priority
        else if (E)
            Q <= w;     // Shift if enabled and no load
        else
            Q <= Q;     // Hold previous value (explicit for clarity)
    end

endmodule
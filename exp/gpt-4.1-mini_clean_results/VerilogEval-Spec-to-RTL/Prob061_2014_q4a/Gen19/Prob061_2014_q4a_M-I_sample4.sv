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
        // else implicitly holds Q without re-assignment to reduce power
    end

endmodule
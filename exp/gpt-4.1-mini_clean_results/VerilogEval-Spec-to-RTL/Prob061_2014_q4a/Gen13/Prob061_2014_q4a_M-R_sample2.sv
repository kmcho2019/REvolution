module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    reg next_Q;

    always @(*) begin
        if (L)
            next_Q = R;      // Load has highest priority
        else if (E)
            next_Q = w;      // Shift on enable
        else
            next_Q = Q;      // Hold previous value
    end

    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule
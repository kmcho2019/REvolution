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
            next_Q = R;      // Load operation has highest priority
        else if (E)
            next_Q = w;      // Shift operation
        else
            next_Q = Q;      // Hold current value
    end

    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule
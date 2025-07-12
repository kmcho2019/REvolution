module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg next_Q;
    wire enable;

    // Calculate next state with explicit priority in combinational always block
    always @(*) begin
        if (L)
            next_Q = R;
        else if (E)
            next_Q = w;
        else
            next_Q = Q;
    end

    // Enable updating Q only when next_Q differs or when load/enable asserted
    assign enable = (next_Q != Q) && (L || E);

    always @(posedge clk) begin
        if (enable)
            Q <= next_Q;
    end

endmodule
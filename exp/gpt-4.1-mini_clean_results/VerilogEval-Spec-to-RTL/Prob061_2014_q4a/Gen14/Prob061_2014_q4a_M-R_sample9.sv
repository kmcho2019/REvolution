module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg next_Q;

    // Combinational logic for next state of Q
    always @(*) begin
        if (L)
            next_Q = R;    // Load has highest priority
        else if (E)
            next_Q = w;    // Shift if enabled and no load
        else
            next_Q = Q;    // Hold previous value
    end

    // Sequential logic: update Q on positive edge of clk only if L or E is asserted
    always @(posedge clk) begin
        if (L || E)
            Q <= next_Q;
    end

endmodule
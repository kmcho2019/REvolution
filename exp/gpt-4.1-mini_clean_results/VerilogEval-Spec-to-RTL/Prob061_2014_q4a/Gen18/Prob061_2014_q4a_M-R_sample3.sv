module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg next_Q;

    // Combinational next state logic
    always @(*) begin
        if (L)
            next_Q = R;     // Load has highest priority
        else if (E)
            next_Q = w;     // Shift if enabled and no load
        else
            next_Q = Q;     // Hold previous value
    end

    // Sequential state update
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule
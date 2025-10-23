module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg next_Q;

    // Combinational logic to select the next value of Q
    always @(*) begin
        if (L)
            next_Q = R;
        else
            next_Q = w;
    end

    // Sequential logic to update Q on clock edge
    always @(posedge clk) begin
        if (L | E)
            Q <= next_Q;
        else
            Q <= Q;  // Hold current value when neither load nor shift is enabled
    end

endmodule
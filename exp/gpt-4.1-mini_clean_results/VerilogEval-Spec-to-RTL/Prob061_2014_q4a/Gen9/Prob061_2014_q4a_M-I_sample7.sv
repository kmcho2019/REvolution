module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg next_Q;
    reg E_reg;

    // Register enable to reduce combinational glitches
    always @(posedge clk) begin
        E_reg <= E;
    end

    // Combinational logic for next state with explicit if-else
    always @(*) begin
        if (L)
            next_Q = R;
        else if (E_reg)
            next_Q = w;
        else
            next_Q = Q;
    end

    // Sequential update
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule
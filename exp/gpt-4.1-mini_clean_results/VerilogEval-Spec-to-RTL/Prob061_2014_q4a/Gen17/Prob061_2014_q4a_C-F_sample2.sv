module TopModule (
    input        clk,
    input        w,
    input        R,
    input        E,
    input        L,
    output reg   Q
);

    wire next_Q;
    wire update_enable;

    // Combinational next state logic with priority: load (L) > shift (E) > retain
    assign next_Q = L ? R : w;
    assign update_enable = L | E;

    always @(posedge clk) begin
        if (update_enable)
            Q <= next_Q;
    end

endmodule
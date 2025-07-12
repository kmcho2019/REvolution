module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    wire enable = L || E;
    wire next_Q;

    // Priority logic via continuous assignment: load > shift > hold
    assign next_Q = L ? R : (E ? w : Q);

    // Sequential logic updates Q on clock edge only when enabled
    always @(posedge clk) begin
        if (enable)
            Q <= next_Q;
    end

endmodule
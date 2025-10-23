module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    // Create delayed version of 'a' using inverter chain
    wire a_delayed;
    not #1 inv1(a_delayed, a);  // First inverter with unit delay
    not #1 inv2(a_delayed, a_delayed);  // Second inverter creates delay

    // Edge detection logic
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule
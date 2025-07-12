module TopModule(
    input clk,
    input d,
    output reg q
);
    reg master_latch;

    always @(posedge clk) master_latch <= d;
    always @(posedge clk) q <= master_latch;

    // Alternatively, to directly achieve the D flip-flop functionality without an extra latch,
    // we simplify to:
    // always @(posedge clk) q <= d;

    // But to adhere to the idea of using latches in a more complex form for educational purposes:
    always @(negedge clk) begin
        // This always block is intentionally left empty to demonstrate the idea
        // that the actual data transfer happens on the positive edge.
    end
endmodule
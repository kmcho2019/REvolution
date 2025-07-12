module TopModule (
    input clk,
    input x,
    output z
);

    // Individual flip-flop outputs
    wire xor_ff, and_ff, or_ff;

    // Gate outputs
    wire xor_out, and_out, or_out;

    // XOR path: x XOR with its flip-flop's output
    assign xor_out = x ^ xor_ff;

    // AND path: x AND with its flip-flop's complemented output
    assign and_out = x & ~and_ff;

    // OR path: x OR with its flip-flop's complemented output
    assign or_out = x | ~or_ff;

    // D flip-flop instances with synchronous reset to 0
    dff xor_flop (.clk(clk), .d(xor_out), .q(xor_ff), .rst(1'b0));
    dff and_flop (.clk(clk), .d(and_out), .q(and_ff), .rst(1'b0));
    dff or_flop  (.clk(clk), .d(or_out),  .q(or_ff),  .rst(1'b0));

    // Output is NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule

// D flip-flop module with synchronous reset
module dff (
    input clk,
    input d,
    input rst,
    output reg q
);
    always @(posedge clk) begin
        if (rst) q <= 1'b0;
        else    q <= d;
    end
endmodule
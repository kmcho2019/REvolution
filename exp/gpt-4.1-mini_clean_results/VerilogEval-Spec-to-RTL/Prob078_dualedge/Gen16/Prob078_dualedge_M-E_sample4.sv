module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg clk_x2;       // internal clock at double freq
    reg d_ff;         // positive-edge triggered flip-flop output
    wire clk_n = ~clk; // inverted clock

    // Generate clk_x2 by toggling at both edges of clk:
    // This is done by setting clk_x2 = clk XOR delayed clk
    // For synthesis-friendly code, we implement clk_x2 toggling on posedge and negedge of clk
    // Note: This approach works for simulation and concept; in FPGA this requires special attention.
    always @(posedge clk or posedge clk_n) begin
        clk_x2 <= ~clk_x2;
    end

    // Flip-flop triggered on posedge of clk_x2 capturing d
    always @(posedge clk_x2) begin
        d_ff <= d;
    end

    // Output latch controlled by original clk: transparent when clk=1, holds value when clk=0
    // This synchronizes output q to clk but ensures updates on both edges of clk via clk_x2 sample.
    always @(clk or d_ff) begin
        if (clk)
            q = d_ff;
        // when clk=0, hold q (no assignment here implies latch behavior)
    end

endmodule
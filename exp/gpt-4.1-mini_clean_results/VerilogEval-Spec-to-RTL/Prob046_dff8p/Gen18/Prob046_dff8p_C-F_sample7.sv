module DFF8_negclk_sync_reset_with_ce #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input                 clk,
    input                 reset,
    input  [WIDTH-1:0]    d,
    output reg [WIDTH-1:0] q
);

    // Load enable: update only if reset is asserted or input d differs from q to reduce toggling
    wire load = reset | (d != q);

    // Negative edge triggered vector register with synchronous active-high reset and clock enable
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else if (load)
            q <= d;
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    // Instantiate the 8-bit DFF with synchronous reset to 0x34, negative edge clocking, and clock enable to reduce toggling
    DFF8_negclk_sync_reset_with_ce #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) dff8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule
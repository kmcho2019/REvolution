module DFF_sync_reset_negclk_vector #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input                  clk,
    input                  reset,
    input  [WIDTH-1:0]     d,
    output reg [WIDTH-1:0] q
);
    // Negative edge triggered vector register with synchronous active-high reset
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else
            q <= d;
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    // Instantiate the vector DFF module with synchronous reset to 0x34
    DFF_sync_reset_negclk_vector #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) reg8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule
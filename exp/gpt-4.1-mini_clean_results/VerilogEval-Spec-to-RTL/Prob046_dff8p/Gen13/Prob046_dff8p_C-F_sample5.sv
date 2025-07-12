module DFF_sync_reset_negclk_vector_en #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input                  clk,
    input                  reset,
    input  [WIDTH-1:0]     d,
    output reg [WIDTH-1:0] q
);
    // Negative edge triggered vector register with synchronous active-high reset
    // and clock enable to reduce unnecessary toggling when input matches output.
    wire ce = (d != q);

    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else if (ce)
            q <= d;
        // else retain q without toggling
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    // Instantiate the enhanced vector DFF module with synchronous reset to 0x34
    DFF_sync_reset_negclk_vector_en #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) reg8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule
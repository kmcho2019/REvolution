module DFF_negclk_sync_reset_vector #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input              clk,
    input              reset,
    input  [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    wire neg_clk = ~clk;

    always @(posedge neg_clk) begin
        if (reset)
            q <= RESET_VAL;
        else
            q <= d;
    end

endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    DFF_negclk_sync_reset_vector #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) reg8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule
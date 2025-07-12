module DFF_negclk_sync_reset_vector #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input              clk,
    input              reset,
    input  [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(negedge clk) begin
        if (reset) begin
            q <= RESET_VAL;
        end else begin
            q <= d;
        end
    end

endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
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
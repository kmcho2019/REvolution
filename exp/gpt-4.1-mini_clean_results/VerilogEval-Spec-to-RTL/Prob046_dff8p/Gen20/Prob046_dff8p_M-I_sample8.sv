module DFF_sync_reset_negclk_vector #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input                  clk,
    input                  reset,
    input      [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    wire enable = reset || (q != d);

    always @(negedge clk) begin
        if (enable) begin
            if (reset)
                q <= RESET_VAL;
            else
                q <= d;
        end
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    DFF_sync_reset_negclk_vector #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) dff_vector_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule
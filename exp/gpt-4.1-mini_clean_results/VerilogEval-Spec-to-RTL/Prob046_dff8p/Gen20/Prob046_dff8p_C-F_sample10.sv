module DFF_negclk_sync_reset_vector_ce #(
    parameter WIDTH = 8,
    parameter [WIDTH-1:0] RESET_VAL = 8'h34
) (
    input                   clk,
    input                   reset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);

    // Clock enable: update only when reset is asserted or d differs from q
    wire clk_en = reset | (| (d ^ q));

    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else if (clk_en)
            q <= d;
    end

endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    DFF_negclk_sync_reset_vector_ce #(
        .WIDTH(8),
        .RESET_VAL(8'h34)
    ) reg8_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule
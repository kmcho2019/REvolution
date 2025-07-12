module DFF_sync_reset_vec #(
    parameter WIDTH = 8
) (
    input               clk,
    input               reset,
    input               ce,        // clock enable to reduce toggling
    input  [WIDTH-1:0]  d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= {WIDTH{1'b0}};
        else if (ce)
            q <= d;
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    wire ce;

    // Generate clock enable: update only when reset is active or d changes from previous stored q
    // To compare d and q, we need a stored q, so instantiate the register first, then generate ce.

    // Instantiate register without ce first to get q for comparison (recursive definition not allowed),
    // so instead create internal wire q_reg and a combinational comparison for ce.

    // Strategy:
    // - Instantiate the DFF with ce.
    // - ce = (reset) || (d != q_reg)
    // So we need to declare q_reg as wire and connect output of DFF to it.

    // Internal wire to capture q from DFF
    wire [7:0] q_reg;

    assign ce = reset || (d != q_reg);

    DFF_sync_reset_vec #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .ce(ce),
        .d(d),
        .q(q_reg)
    );

    assign q = q_reg;

endmodule
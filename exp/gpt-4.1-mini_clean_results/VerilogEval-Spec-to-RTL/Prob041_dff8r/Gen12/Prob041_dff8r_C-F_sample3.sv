module DFF_sync_reset_vec_ce #(
    parameter WIDTH = 8
) (
    input               clk,
    input               reset,
    input               ce,
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

    // Clock enable asserted when reset is active or input differs from stored value
    assign ce = reset | (d != q);

    DFF_sync_reset_vec_ce #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .ce(ce),
        .d(d),
        .q(q)
    );
endmodule
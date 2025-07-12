module DFF_sync_reset_vec #(
    parameter WIDTH = 8
) (
    input               clk,
    input               reset,
    input               en,
    input  [WIDTH-1:0]  d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= {WIDTH{1'b0}};
        else if (en)
            q <= d;
        // else retain q (no change)
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    // Internal clock enable: update only if data changes or reset asserted
    wire en = reset || (q != d);

    DFF_sync_reset_vec #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d),
        .q(q)
    );
endmodule
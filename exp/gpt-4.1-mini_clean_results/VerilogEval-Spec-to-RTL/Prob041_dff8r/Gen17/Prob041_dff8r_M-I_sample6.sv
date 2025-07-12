module DFF_sync_reset_vec_en #(
    parameter WIDTH = 8
) (
    input               clk,
    input               reset,
    input  [WIDTH-1:0]  d,
    output reg [WIDTH-1:0] q
);
    // Clock enable to update only on data change or reset assertion
    wire ce = (d != q) || reset;

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
    DFF_sync_reset_vec_en #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule
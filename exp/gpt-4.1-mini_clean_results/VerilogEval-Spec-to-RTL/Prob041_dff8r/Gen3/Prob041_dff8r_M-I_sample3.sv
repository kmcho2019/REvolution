module DFF_sync_reset_vec #(
    parameter WIDTH = 8
) (
    input               clk,
    input               reset,
    input               clk_en,
    input  [WIDTH-1:0]  d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= {WIDTH{1'b0}};
        else if (clk_en)
            q <= d;
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    wire clk_en;
    assign clk_en = (d != q);  // Enable clock only when input data changes

    DFF_sync_reset_vec #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .clk_en(clk_en),
        .d(d),
        .q(q)
    );
endmodule
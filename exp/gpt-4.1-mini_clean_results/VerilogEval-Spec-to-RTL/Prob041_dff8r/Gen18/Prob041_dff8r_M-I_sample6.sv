module DFF_sync_reset_en_vec #(
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
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    wire en;

    // Enable update only when input data differs from current output or reset is asserted
    assign en = reset | (d != q);

    // Instantiate the 8-bit DFF module with enable and synchronous reset
    DFF_sync_reset_en_vec #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d),
        .q(q)
    );
endmodule
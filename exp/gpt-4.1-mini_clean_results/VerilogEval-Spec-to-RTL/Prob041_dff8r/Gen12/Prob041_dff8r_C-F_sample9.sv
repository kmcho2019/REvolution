module DFF_sync_reset #(
    parameter WIDTH = 8
) (
    input               clk,
    input               reset,
    input  [WIDTH-1:0]  d,
    output reg [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i=0; i<WIDTH; i=i+1) begin : bit_dff
            always @(posedge clk) begin
                if (reset)
                    q[i] <= 1'b0;
                else
                    q[i] <= d[i];
            end
        end
    endgenerate
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    DFF_sync_reset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule
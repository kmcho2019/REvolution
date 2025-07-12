module DFF_SyncReset (
    input  wire clk,
    input  wire reset,
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            DFF_SyncReset dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule
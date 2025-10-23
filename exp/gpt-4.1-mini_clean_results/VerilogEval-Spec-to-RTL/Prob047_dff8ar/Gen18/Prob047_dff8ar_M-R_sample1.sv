module DFF_AsyncReset (
    input  wire clk,
    input  wire areset,
    input  wire d,
    output reg  q
);
    // Asynchronous reset, active high, with posedge clk triggering data latch
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : DFF_ARRAY
            DFF_AsyncReset dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule
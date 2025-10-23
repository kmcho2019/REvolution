module SyncDFF (
    input  clk,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  ar,   // asynchronous active-high reset
    input  d,
    output q
);
    wire dff_q;

    // Instantiate a synchronous D flip-flop (no async reset here)
    SyncDFF dff_inst (
        .clk(clk),
        .d(d),
        .q(dff_q)
    );

    // Asynchronously force q to 0 when ar=1, otherwise output flip-flop value
    assign q = ar ? 1'b0 : dff_q;

endmodule
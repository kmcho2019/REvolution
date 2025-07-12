module ResetSynchronizer(
    input clk,
    input async_rst,
    output sync_rst
);
    reg rst_meta;
    always @(posedge clk or posedge async_rst) begin
        if (async_rst) begin
            rst_meta <= 1'b1;
            sync_rst <= 1'b1;
        end else begin
            rst_meta <= 1'b0;
            sync_rst <= rst_meta;
        end
    end
endmodule

module CoreFlipFlop(
    input clk,
    input sync_rst,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (sync_rst) q <= 1'b0;
        else          q <= d;
    end
endmodule

module TopModule(
    input clk,
    input ar,
    input d,
    output q
);
    wire synchronized_reset;
    
    ResetSynchronizer sync_inst(
        .clk(clk),
        .async_rst(ar),
        .sync_rst(synchronized_reset)
    );
    
    CoreFlipFlop ff_inst(
        .clk(clk),
        .sync_rst(synchronized_reset),
        .d(d),
        .q(q)
    );
endmodule
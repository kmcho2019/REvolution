module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    // Compile-time check for power-of-2 depth
    if ((DEPTH & (DEPTH-1)) != 0) begin
        $error("DEPTH must be power of 2");
        $finish;
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Binary pointers
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    
    // Gray code conversion (combinational)
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    
    // Synchronized pointers (optimized 2-stage synchronizer)
    reg [PTR_WIDTH-1:0] wptr_sync_rclk, wptr_sync_rclk_ff;
    reg [PTR_WIDTH-1:0] rptr_sync_wclk, rptr_sync_wclk_ff;
    
    // Cross-clock domain synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync_rclk, wptr_sync_rclk_ff} <= 0;
        else        {wptr_sync_rclk, wptr_sync_rclk_ff} <= {wptr_gray, wptr_sync_rclk};
    end
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync_wclk, rptr_sync_wclk_ff} <= 0;
        else        {rptr_sync_wclk, rptr_sync_wclk_ff} <= {rptr_gray, rptr_sync_wclk};
    end
    
    // Optimized status flags
    assign wfull = (wptr_gray == {~rptr_sync_wclk_ff[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync_wclk_ff[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync_rclk_ff);
    
    // Memory control with clock gating opportunities
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    
    // Pointer update with optimized arithmetic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wptr_bin <= 0;
        else if (wenc) wptr_bin <= wptr_bin + 1'b1;
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rptr_bin <= 0;
        else if (renc) rptr_bin <= rptr_bin + 1'b1;
    end
    
    // Power-optimized dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    // Power-aware memory implementation
    (* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write port with explicit enable
    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end
    
    // Read port with explicit enable
    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
        else      rdata <= {WIDTH{1'b0}}; // Output zero when not reading (optional)
    end

endmodule
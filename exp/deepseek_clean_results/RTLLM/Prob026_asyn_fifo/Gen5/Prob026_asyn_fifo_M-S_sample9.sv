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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // RAM signals
    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    
    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write port
    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end
    
    // Read port
    always @(posedge rclk) begin
        if (ren) rdata <= mem[raddr];
    end
    
    // Pointers
    reg [ADDR_WIDTH:0] wptr, rptr;
    wire [ADDR_WIDTH:0] wgray = wptr ^ (wptr >> 1);
    wire [ADDR_WIDTH:0] rgray = rptr ^ (rptr >> 1);
    
    // Write pointer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wptr <= 0;
        else if (wen) wptr <= wptr + 1;
    end
    
    // Read pointer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rptr <= 0;
        else if (ren) rptr <= rptr + 1;
    end
    
    // Pointer synchronization
    reg [ADDR_WIDTH:0] w2r_sync, r2w_sync;
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) w2r_sync <= 0;
        else w2r_sync <= wgray;
    end
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) r2w_sync <= 0;
        else r2w_sync <= rgray;
    end
    
    // Address and flag assignments
    assign waddr = wptr[ADDR_WIDTH-1:0];
    assign raddr = rptr[ADDR_WIDTH-1:0];
    
    assign wfull = (wgray == {~r2w_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                             r2w_sync[ADDR_WIDTH-2:0]});
    assign rempty = (rgray == w2r_sync);

endmodule
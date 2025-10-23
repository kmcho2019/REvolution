module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Ping-pong buffer control
    reg ping_pong;
    wire active_bank = ping_pong;
    wire shadow_bank = ~ping_pong;
    
    // Dual-port RAM with ping-pong banks
    dual_port_ram_pp #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr({active_bank, waddr_bin[ADDR_WIDTH-1:0]}),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr({shadow_bank, raddr_bin[ADDR_WIDTH-1:0]}),
        .rdata(rdata)
    );

    // Write domain
    reg [PTR_WIDTH-1:0] waddr_bin, wptr_gray, wptr_next_gray;
    reg [PTR_WIDTH-1:0] rptr_sync [0:2];  // 3-stage sync
    
    // Read domain
    reg [PTR_WIDTH-1:0] raddr_bin, rptr_gray, rptr_next_gray;
    reg [PTR_WIDTH-1:0] wptr_sync [0:2];  // 3-stage sync
    
    // Gray code pre-computation
    wire [PTR_WIDTH-1:0] wbin_next = waddr_bin + 1;
    wire [PTR_WIDTH-1:0] rbin_next = raddr_bin + 1;
    
    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr_gray <= 0;
            wptr_next_gray <= 1;
            ping_pong <= 0;
        end else if (winc && !wfull) begin
            waddr_bin <= wbin_next;
            wptr_gray <= wptr_next_gray;
            wptr_next_gray <= (wbin_next + 1) ^ ((wbin_next + 1) >> 1);
            
            // Switch banks when reaching half-full
            if (wbin_next[PTR_WIDTH-1] && !waddr_bin[PTR_WIDTH-1])
                ping_pong <= ~ping_pong;
        end
    end
    
    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr_gray <= 0;
            rptr_next_gray <= 1;
        end else if (rinc && !rempty) begin
            raddr_bin <= rbin_next;
            rptr_gray <= rptr_next_gray;
            rptr_next_gray <= (rbin_next + 1) ^ ((rbin_next + 1) >> 1);
        end
    end
    
    // Hierarchical synchronization
    always @(posedge wclk) begin
        rptr_sync[0] <= rptr_gray;
        rptr_sync[1] <= rptr_sync[0];
        rptr_sync[2] <= rptr_sync[1];
    end
    
    always @(posedge rclk) begin
        wptr_sync[0] <= wptr_gray;
        wptr_sync[1] <= wptr_sync[0];
        wptr_sync[2] <= wptr_sync[1];
    end
    
    // Predictive status flags
    always @(posedge wclk) begin
        wfull <= (wptr_next_gray == {~rptr_sync[2][PTR_WIDTH-1:PTR_WIDTH-2], 
                                  rptr_sync[2][PTR_WIDTH-3:0]});
    end
    
    always @(posedge rclk) begin
        rempty <= (rptr_next_gray == wptr_sync[2]);
    end

endmodule

module dual_port_ram_pp #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH):0] waddr,  // Extra bit for ping-pong
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH):0] raddr,  // Extra bit for ping-pong
    output reg [WIDTH-1:0] rdata
);

    // Two banks for ping-pong operation
    reg [WIDTH-1:0] mem [0:(2*DEPTH)-1];
    
    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule
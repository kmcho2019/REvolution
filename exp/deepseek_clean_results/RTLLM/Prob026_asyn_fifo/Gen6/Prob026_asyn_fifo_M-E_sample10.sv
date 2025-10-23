module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter EARLY_WARN = 2
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg w_almost_full,
    output reg r_almost_empty,
    output [WIDTH-1:0] rdata,
    output reg sync_error  // New metastability error indicator
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Clock ratio detection
    reg [3:0] clk_ratio;
    reg [3:0] wclk_sample, rclk_sample;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wclk_sample <= 0;
        end else begin
            wclk_sample <= wclk_sample + 1;
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rclk_sample <= 0;
        end else begin
            rclk_sample <= rclk_sample + 1;
            if (rclk_sample == 15) begin
                clk_ratio <= wclk_sample;
                wclk_sample <= 0;
            end
        end
    end
    
    // Pointer management
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    
    // Hybrid synchronization
    reg [PTR_WIDTH-1:0] wptr_sync_gray, rptr_sync_gray;
    reg [PTR_WIDTH-1:0] wptr_sync_bin, rptr_sync_bin;
    reg [PTR_WIDTH-1:0] wptr_sync, rptr_sync;
    
    // Gray code synchronization (2-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync_gray, wptr_sync_bin} <= 0;
        end else begin
            wptr_sync_gray <= wptr_gray;
            wptr_sync_bin <= wptr_bin;
        end
    end
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync_gray, rptr_sync_bin} <= 0;
        end else begin
            rptr_sync_gray <= rptr_gray;
            rptr_sync_bin <= rptr_bin;
        end
    end
    
    // Adaptive pointer selection
    always @(*) begin
        if (clk_ratio > 4) begin
            // Fast write clock - use Gray code
            wptr_sync = wptr_sync_gray;
            rptr_sync = rptr_sync_gray;
        end else begin
            // Similar clocks - use binary with error check
            wptr_sync = wptr_sync_bin;
            rptr_sync = rptr_sync_bin;
        end
    end
    
    // Metastability error detection
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            sync_error <= 0;
        end else begin
            sync_error <= (wptr_sync_gray ^ (wptr_sync_gray >> 1)) != wptr_sync_bin;
        end
    end
    
    // Predictive status generation
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + winc;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + rinc;
    
    // Sliding window comparison
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
            w_almost_full <= 0;
        end else begin
            wfull <= (wptr_next[PTR_WIDTH-1] != rptr_sync[PTR_WIDTH-1]) && 
                    (wptr_next[PTR_WIDTH-2:0] == rptr_sync[PTR_WIDTH-2:0]);
            w_almost_full <= (wptr_next - rptr_sync) >= (DEPTH - EARLY_WARN);
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
            r_almost_empty <= 1;
        end else begin
            rempty <= (rptr_bin == wptr_sync);
            r_almost_empty <= (wptr_sync - rptr_bin) <= EARLY_WARN;
        end
    end
    
    // Memory interface with clock gating
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    
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
    
    // Gated pointer updates
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_next;
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_next;
        end
    end

endmodule

// Enhanced dual-port RAM with write-through caching
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

    (* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] cache_data;
    reg [$clog2(DEPTH)-1:0] cache_addr;
    reg cache_valid;
    
    // Write port with caching
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
            cache_data <= wdata;
            cache_addr <= waddr;
            cache_valid <= 1;
        end
    end
    
    // Read port with cache bypass
    always @(posedge rclk) begin
        if (renc) begin
            if (cache_valid && (cache_addr == raddr)) begin
                rdata <= cache_data;
            end else begin
                rdata <= mem[raddr];
            end
        end
    end

endmodule
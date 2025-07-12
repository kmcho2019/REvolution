module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter EARLY_WARNING = 1  // Enable early full/empty warnings
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
    output reg w_almost_full,  // Early warning
    output reg r_almost_empty, // Early warning
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    localparam WARNING_OFFSET = DEPTH >> 2; // 25% threshold
    
    // Memory interface
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];
    
    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr;
    reg [PTR_WIDTH-1:0] rmirror;  // Mirrored read pointer
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr;
    reg [PTR_WIDTH-1:0] wmirror;  // Mirrored write pointer
    
    // Synchronization registers
    reg [PTR_WIDTH-1:0] rptr_sync [0:1];
    reg [PTR_WIDTH-1:0] wptr_sync [0:1];
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (wenc) begin
            wptr <= wptr + 1'b1;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else if (renc) begin
            rptr <= rptr + 1'b1;
        end
    end
    
    // Pointer mirroring - write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rmirror <= 0;
        end else begin
            rptr_sync[0] <= rptr;
            rptr_sync[1] <= rptr_sync[0];
            rmirror <= rptr_sync[1];
        end
    end
    
    // Pointer mirroring - read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wmirror <= 0;
        end else begin
            wptr_sync[0] <= wptr;
            wptr_sync[1] <= wptr_sync[0];
            wmirror <= wptr_sync[1];
        end
    end
    
    // Status detection
    always @(*) begin
        // Full when write pointer catches read mirror
        wfull = (wptr - rmirror) >= DEPTH;
        
        // Empty when read pointer catches write mirror
        rempty = (wmirror - rptr) == 0;
        
        // Early warnings if enabled
        if (EARLY_WARNING) begin
            w_almost_full = (wptr - rmirror) >= (DEPTH - WARNING_OFFSET);
            r_almost_empty = (wmirror - rptr) <= WARNING_OFFSET;
        end else begin
            w_almost_full = 0;
            r_almost_empty = 0;
        end
    end

endmodule

// Dual-port RAM module (same as previous)
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule
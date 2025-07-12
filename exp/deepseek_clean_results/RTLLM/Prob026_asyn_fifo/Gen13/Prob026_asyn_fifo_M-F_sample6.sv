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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Dual-port RAM instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] waddr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    wire [PTR_WIDTH-1:0] waddr_next = waddr_bin + (winc && !wfull);
    wire [PTR_WIDTH-1:0] wptr_gray_next = waddr_next ^ (waddr_next >> 1);
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] raddr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    wire [PTR_WIDTH-1:0] raddr_next = raddr_bin + (rinc && !rempty);
    wire [PTR_WIDTH-1:0] rptr_gray_next = raddr_next ^ (raddr_next >> 1);
    
    // Synchronization registers
    reg [PTR_WIDTH-1:0] sync_r2w [0:1]; // 2-stage read to write sync
    reg [PTR_WIDTH-1:0] sync_w2r [0:1]; // 2-stage write to read sync
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            waddr_bin <= waddr_next;
            wptr_gray <= wptr_gray_next;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            raddr_bin <= raddr_next;
            rptr_gray <= rptr_gray_next;
        end
    end
    
    // Read to write domain synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            sync_r2w[0] <= 0;
            sync_r2w[1] <= 0;
        end else begin
            sync_r2w[0] <= rptr_gray;
            sync_r2w[1] <= sync_r2w[0];
        end
    end
    
    // Write to read domain synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            sync_w2r[0] <= 0;
            sync_w2r[1] <= 0;
        end else begin
            sync_w2r[0] <= wptr_gray;
            sync_w2r[1] <= sync_w2r[0];
        end
    end
    
    // Full condition: Gray code comparison (MSB and next-MSB differ, others same)
    assign wfull = (wptr_gray == {~sync_r2w[1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                 sync_r2w[1][PTR_WIDTH-3:0]});
    
    // Empty condition: pointers equal
    assign rempty = (rptr_gray == sync_w2r[1]);

endmodule

// Dual-port RAM module
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
    
    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end
    
    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    // Calculate address width from DEPTH
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; 
    // Use one extra bit in pointer for distinguishing full/empty and implementing Gray code (since full condition checks MSBs differently)

    // ---------- Dual-port RAM Submodule ----------
    // Dual-port RAM as per specification:
    // wclk, wenc, waddr, wdata
    // rclk, renc, raddr, rdata
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // ---------- Write Pointer Logic ----------
    reg [PTR_WIDTH-1:0] waddr_bin;  // Binary write pointer
    reg [PTR_WIDTH-1:0] wptr;       // Gray-coded write pointer

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc && !wfull) begin
            waddr_bin <= waddr_bin + 1'b1;
        end
    end

    // Convert write pointer to Gray code
    always @(*) begin
        wptr = (waddr_bin >> 1) ^ waddr_bin;
    end

    // ---------- Read Pointer Logic ----------
    reg [PTR_WIDTH-1:0] raddr_bin;  // Binary read pointer
    reg [PTR_WIDTH-1:0] rptr;       // Gray-coded read pointer

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc && !rempty) begin
            raddr_bin <= raddr_bin + 1'b1;
        end
    end

    // Convert read pointer to Gray code
    always @(*) begin
        rptr = (raddr_bin >> 1) ^ raddr_bin;
    end

    // ---------- Synchronizers ----------
    // Synchronize read pointer into write clock domain
    reg [PTR_WIDTH-1:0] rptr_sync1_wclk, rptr_sync2_wclk;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_sync1_wclk <= 0;
            rptr_sync2_wclk <= 0;
        end else begin
            rptr_sync1_wclk <= rptr;
            rptr_sync2_wclk <= rptr_sync1_wclk;
        end
    end

    // Synchronize write pointer into read clock domain
    reg [PTR_WIDTH-1:0] wptr_sync1_rclk, wptr_sync2_rclk;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_sync1_rclk <= 0;
            wptr_sync2_rclk <= 0;
        end else begin
            wptr_sync1_rclk <= wptr;
            wptr_sync2_rclk <= wptr_sync1_rclk;
        end
    end

    // ---------- Full and Empty Flags ----------
    // FIFO full condition:
    // When write pointer is one ahead of read pointer in circular buffer:
    // Check Gray code condition: 
    // MSB and MSB-1 bits of write pointer and read pointer are inverted, lower bits equal
    // Using PTR_WIDTH bits, bits [PTR_WIDTH-1] and [PTR_WIDTH-2] are MSB and second MSB
    wire full_cond;
    assign full_cond = ( (wptr[PTR_WIDTH-1]      != rptr_sync2_wclk[PTR_WIDTH-1]) &&
                         (wptr[PTR_WIDTH-2]      != rptr_sync2_wclk[PTR_WIDTH-2]) &&
                         (wptr[PTR_WIDTH-3:0]   == rptr_sync2_wclk[PTR_WIDTH-3:0]) );

    assign wfull = full_cond;

    // FIFO empty condition:
    // When read pointer equals synchronized write pointer
    assign rempty = (rptr == wptr_sync2_rclk);

    // ---------- Enable signals ----------
    // Write enable when write increment requested and FIFO not full
    wire wen = winc && !wfull;
    // Read enable when read increment requested and FIFO not empty
    wire ren = rinc && !rempty;

    // ---------- Addresses for RAM ----------
    // Use lower ADDR_WIDTH bits of binary pointers as RAM addresses
    wire [ADDR_WIDTH-1:0] waddr_bin_lower = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_bin_lower = raddr_bin[ADDR_WIDTH-1:0];

    // For connection to RAM module ports:
    // waddr connected to waddr_bin_lower
    // raddr connected to raddr_bin_lower

    // Assign the addresses for the RAM instantiation:
    assign waddr_bin = waddr_bin;  // redundant but clarifies usage
    assign raddr_bin = raddr_bin;

endmodule


// Dual-port RAM module as requested
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    // RAM storage
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation - synchronous on wclk
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation - synchronous on rclk
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            // Hold previous data if no read enable, optional
            rdata <= rdata;
        end
    end

endmodule
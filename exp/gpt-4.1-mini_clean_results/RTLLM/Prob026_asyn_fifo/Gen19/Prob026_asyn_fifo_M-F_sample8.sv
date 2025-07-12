`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,   // active low write reset
    input                 rrstn,   // active low read reset
    input                 winc,    // write increment
    input                 rinc,    // read increment
    input  [WIDTH-1:0]    wdata,   // data input
    output                wfull,   // fifo full flag
    output                rempty,  // fifo empty flag
    output [WIDTH-1:0]    rdata    // data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH); // Number of address bits, e.g. 4 for DEPTH=16
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // Pointer width for full/empty detection (one extra MSB)

    // -------------------------
    // Write pointer domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;      // Write pointer binary
    reg [PTR_WIDTH-1:0] wptr_gray = 0;     // Write pointer Gray code
    reg [PTR_WIDTH-1:0] wptr_gray_next = 0;

    // -------------------------
    // Read pointer domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;      // Read pointer binary
    reg [PTR_WIDTH-1:0] rptr_gray = 0;     // Read pointer Gray code
    reg [PTR_WIDTH-1:0] rptr_gray_next = 0;

    // -------------------------
    // Synchronizers for crossing clock domains (two-stage flip-flops)
    reg [PTR_WIDTH-1:0] rptr_gray_sync_wclk_0 = 0, rptr_gray_sync_wclk_1 = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync_rclk_0 = 0, wptr_gray_sync_rclk_1 = 0;

    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk = rptr_gray_sync_wclk_1;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk = wptr_gray_sync_rclk_1;

    // -------------------------
    // RAM addresses are lower ADDR_WIDTH bits of binary pointers (converted from gray)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // -------------------------
    // Gray code conversion function (binary to gray)
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i=i-1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Gray to binary conversion function
    // Used to convert Gray code pointer to binary address
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // -------------------------
    // Write pointer update (in write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wptr_gray_next <= 0;
        end else begin
            if (winc && !wfull) begin
                wptr_bin <= wptr_bin + 1;
                wptr_gray <= bin2gray(wptr_bin + 1);
                wptr_gray_next <= bin2gray(wptr_bin + 1);
            end else begin
                // Hold current pointers if no write increment or full
                wptr_bin <= wptr_bin;
                wptr_gray <= wptr_gray;
                wptr_gray_next <= wptr_gray_next;
            end
        end
    end

    // -------------------------
    // Read pointer update (in read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rptr_gray_next <= 0;
        end else begin
            if (rinc && !rempty) begin
                rptr_bin <= rptr_bin + 1;
                rptr_gray <= bin2gray(rptr_bin + 1);
                rptr_gray_next <= bin2gray(rptr_bin + 1);
            end else begin
                // Hold current pointers if no read increment or empty
                rptr_bin <= rptr_bin;
                rptr_gray <= rptr_gray;
                rptr_gray_next <= rptr_gray_next;
            end
        end
    end

    // -------------------------
    // Synchronize read pointer gray code into write clock domain (two flip-flops)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk_0 <= 0;
            rptr_gray_sync_wclk_1 <= 0;
        end else begin
            rptr_gray_sync_wclk_0 <= rptr_gray;
            rptr_gray_sync_wclk_1 <= rptr_gray_sync_wclk_0;
        end
    end

    // Synchronize write pointer gray code into read clock domain (two flip-flops)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk_0 <= 0;
            wptr_gray_sync_rclk_1 <= 0;
        end else begin
            wptr_gray_sync_rclk_0 <= wptr_gray;
            wptr_gray_sync_rclk_1 <= wptr_gray_sync_rclk_0;
        end
    end

    // -------------------------
    // Full flag generation (write clock domain)
    // FIFO full condition:
    // When the write pointer has advanced 1 cycle more than read pointer in circular buffer,
    // the highest and 2nd highest bits of wptr and rptr are inverted, other bits equal.
    wire full_flag;
    assign full_flag =
           (wptr_gray_next[PTR_WIDTH-1]     != rptr_gray_sync_wclk[PTR_WIDTH-1])     &&
           (wptr_gray_next[PTR_WIDTH-2]     != rptr_gray_sync_wclk[PTR_WIDTH-2])     &&
           (wptr_gray_next[PTR_WIDTH-3:0]  == rptr_gray_sync_wclk[PTR_WIDTH-3:0]);

    assign wfull = full_flag;

    // -------------------------
    // Empty flag generation (read clock domain)
    // FIFO empty condition: read pointer gray equals synchronized write pointer gray
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // -------------------------
    // Write enable for RAM: when writing is allowed (write increment and not full)
    wire w_en = winc && !wfull;

    // Read enable for RAM: when reading is allowed (read increment and not empty)
    wire r_en = rinc && !rempty;

    // -------------------------
    // Read data wire from RAM
    wire [WIDTH-1:0] ram_rdata;

    // -------------------------
    // Instantiate dual-port RAM as submodule (per specification)
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -------------------------
    // Register RAM output data in read clock domain when read enabled
    reg [WIDTH-1:0] rdata_reg = {WIDTH{1'b0}};
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (r_en)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

endmodule


// -------------------------
// Dual-port RAM module as requested
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]          wdata,
    input                       rclk,
    input                       renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);

    // RAM storage
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule
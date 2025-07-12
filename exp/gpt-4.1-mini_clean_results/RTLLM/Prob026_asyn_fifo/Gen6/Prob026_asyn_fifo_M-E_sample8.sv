`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input              wclk,
    input              rclk,
    input              wrstn,
    input              rrstn,
    input              winc,
    input              rinc,
    input  [WIDTH-1:0] wdata,
    output             wfull,
    output             rempty,
    output reg [WIDTH-1:0] rdata
);

    // Calculate address and pointer widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // One bit extra for full/empty detection

    // Write pointer in binary and Gray code
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;

    // Read pointer in binary and Gray code
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;

    // Synchronizers for pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_gray_sync_wclk_ff1, rptr_gray_sync_wclk_ff2;
    reg [PTR_WIDTH-1:0] wptr_gray_sync_rclk_ff1, wptr_gray_sync_rclk_ff2;

    // Convert binary to Gray code function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Convert Gray code to binary function
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Write pointer update (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else begin
            if(winc && !wfull) begin
                wptr_bin <= wptr_bin + 1'b1;
                wptr_gray <= bin2gray(wptr_bin + 1'b1);
            end else begin
                wptr_bin <= wptr_bin;
                wptr_gray <= wptr_gray;
            end
        end
    end

    // Read pointer update (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else begin
            if(rinc && !rempty) begin
                rptr_bin <= rptr_bin + 1'b1;
                rptr_gray <= bin2gray(rptr_bin + 1'b1);
            end else begin
                rptr_bin <= rptr_bin;
                rptr_gray <= rptr_gray;
            end
        end
    end

    // Synchronize read pointer into write clock domain (two stage)
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn) begin
            rptr_gray_sync_wclk_ff1 <= 0;
            rptr_gray_sync_wclk_ff2 <= 0;
        end else begin
            rptr_gray_sync_wclk_ff1 <= rptr_gray;
            rptr_gray_sync_wclk_ff2 <= rptr_gray_sync_wclk_ff1;
        end
    end

    // Synchronize write pointer into read clock domain (two stage)
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn) begin
            wptr_gray_sync_rclk_ff1 <= 0;
            wptr_gray_sync_rclk_ff2 <= 0;
        end else begin
            wptr_gray_sync_rclk_ff1 <= wptr_gray;
            wptr_gray_sync_rclk_ff2 <= wptr_gray_sync_rclk_ff1;
        end
    end

    // RAM write address (lower bits of binary pointer)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];

    // RAM read address (lower bits of binary pointer)
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable gated by full
    wire w_en = winc && !wfull;

    // Read enable gated by empty
    wire r_en = rinc && !rempty;

    // Full detection:
    // FIFO is full when the next write pointer's Gray code equals
    // the read pointer's Gray code synchronized in write clock domain,
    // except MSB and next MSB are inverted.
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin + 1'b1);

    assign wfull = ( (wptr_gray_next[PTR_WIDTH-3:0] == rptr_gray_sync_wclk_ff2[PTR_WIDTH-3:0]) &&
                     (wptr_gray_next[PTR_WIDTH-1] != rptr_gray_sync_wclk_ff2[PTR_WIDTH-1]) &&
                     (wptr_gray_next[PTR_WIDTH-2] != rptr_gray_sync_wclk_ff2[PTR_WIDTH-2]) );

    // Empty detection: FIFO is empty when read pointer equals write pointer synchronized in read clock domain
    assign rempty = (rptr_gray == wptr_gray_sync_rclk_ff2);

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    // Register read data on read clock at read enable
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if(r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM module
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

endmodule

// Dual-port RAM with independent clocks and enables
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                      rclk,
    input                      renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if(wenc)
            mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if(renc)
            rdata <= mem[raddr];
    end

endmodule
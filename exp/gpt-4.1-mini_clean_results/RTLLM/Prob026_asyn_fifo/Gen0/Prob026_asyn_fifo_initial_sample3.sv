`timescale 1ns/1ps
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,
    input                 rrstn,
    input                 winc,
    input                 rinc,
    input      [WIDTH-1:0] wdata,
    output reg            wfull,
    output reg            rempty,
    output     [WIDTH-1:0] rdata
);

// Calculate address width from DEPTH
localparam ADDR_WIDTH = $clog2(DEPTH);
localparam PTR_WIDTH = ADDR_WIDTH + 1;  // Pointer width for full/empty logic (gray pointers are one bit wider)

// ---------------------------------------------------------------------------------
// Dual-port RAM submodule
// ---------------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,
    input                    wenc,
    input      [ADDR_WIDTH-1:0] waddr,
    input      [WIDTH-1:0]   wdata,
    input                    rclk,
    input                    renc,
    input      [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0]   rdata
);
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if(wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if(renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end
endmodule

// Instantiate RAM
wire [ADDR_WIDTH-1:0] waddr_ram, raddr_ram;
wire wenc_ram, renc_ram;
wire [WIDTH-1:0] rdata_ram;

dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wenc_ram),
    .waddr(waddr_ram),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc_ram),
    .raddr(raddr_ram),
    .rdata(rdata_ram)
);

// ---------------------------------------------------------------------------------
// Binary to Gray code conversion
// ---------------------------------------------------------------------------------
function [PTR_WIDTH-1:0] bin2gray;
    input [PTR_WIDTH-1:0] bin;
    integer i;
    begin
        bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
        for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
            bin2gray[i] = bin[i+1] ^ bin[i];
        end
    end
endfunction

// Gray to Binary conversion
// For pointer comparison, we usually convert gray to binary
function [PTR_WIDTH-1:0] gray2bin;
    input [PTR_WIDTH-1:0] gray;
    integer i;
    begin
        gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
        for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    end
endfunction

// ---------------------------------------------------------------------------------
// Write pointer binary and gray
// ---------------------------------------------------------------------------------
reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
reg [PTR_WIDTH-1:0] wptr_bin_next, wptr_gray_next;

always @(posedge wclk or negedge wrstn) begin
    if(!wrstn) begin
        wptr_bin <= {PTR_WIDTH{1'b0}};
        wptr_gray <= {PTR_WIDTH{1'b0}};
    end else begin
        wptr_bin <= wptr_bin_next;
        wptr_gray <= wptr_gray_next;
    end
end

// Update wptr_bin_next when write occurs and FIFO not full
always @(*) begin
    if(winc && !wfull)
        wptr_bin_next = wptr_bin + 1'b1;
    else
        wptr_bin_next = wptr_bin;
    wptr_gray_next = bin2gray(wptr_bin_next);
end

// ---------------------------------------------------------------------------------
// Read pointer binary and gray
// ---------------------------------------------------------------------------------
reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
reg [PTR_WIDTH-1:0] rptr_bin_next, rptr_gray_next;

always @(posedge rclk or negedge rrstn) begin
    if(!rrstn) begin
        rptr_bin <= {PTR_WIDTH{1'b0}};
        rptr_gray <= {PTR_WIDTH{1'b0}};
    end else begin
        rptr_bin <= rptr_bin_next;
        rptr_gray <= rptr_gray_next;
    end
end

// Update rptr_bin_next when read occurs and FIFO not empty
always @(*) begin
    if(rinc && !rempty)
        rptr_bin_next = rptr_bin + 1'b1;
    else
        rptr_bin_next = rptr_bin;
    rptr_gray_next = bin2gray(rptr_bin_next);
end

// ---------------------------------------------------------------------------------
// Synchronize read pointer to write clock domain (for full detection)
// ---------------------------------------------------------------------------------
reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync1, rptr_gray_wclk_sync2;
always @(posedge wclk or negedge wrstn) begin
    if(!wrstn) begin
        rptr_gray_wclk_sync1 <= 0;
        rptr_gray_wclk_sync2 <= 0;
    end else begin
        rptr_gray_wclk_sync1 <= rptr_gray;
        rptr_gray_wclk_sync2 <= rptr_gray_wclk_sync1;
    end
end

// ---------------------------------------------------------------------------------
// Synchronize write pointer to read clock domain (for empty detection)
// ---------------------------------------------------------------------------------
reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync1, wptr_gray_rclk_sync2;
always @(posedge rclk or negedge rrstn) begin
    if(!rrstn) begin
        wptr_gray_rclk_sync1 <= 0;
        wptr_gray_rclk_sync2 <= 0;
    end else begin
        wptr_gray_rclk_sync1 <= wptr_gray;
        wptr_gray_rclk_sync2 <= wptr_gray_rclk_sync1;
    end
end

// ---------------------------------------------------------------------------------
// Full and empty flag logic
// ---------------------------------------------------------------------------------
// For full detection: when write pointer's binary address is one ahead of read pointer's binary address with specific MSB conditions
// Based on Gray code, full when:
// wptr_gray == {~rptr_gray_wclk_sync2[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_wclk_sync2[PTR_WIDTH-3:0]}
wire full_condition;
assign full_condition = (wptr_gray == {~rptr_gray_wclk_sync2[PTR_WIDTH-1], ~rptr_gray_wclk_sync2[PTR_WIDTH-2], rptr_gray_wclk_sync2[PTR_WIDTH-3:0]});

// Empty condition when read pointer equals synchronized write pointer
wire empty_condition;
assign empty_condition = (rptr_gray == wptr_gray_rclk_sync2);

// Generate output flags
always @(posedge wclk or negedge wrstn) begin
    if(!wrstn)
        wfull <= 1'b0;
    else
        wfull <= full_condition;
end

always @(posedge rclk or negedge rrstn) begin
    if(!rrstn)
        rempty <= 1'b1; // empty after reset
    else
        rempty <= empty_condition;
end

// ---------------------------------------------------------------------------------
// RAM addresses: lower bits of binary pointers (ignore MSB)
// ---------------------------------------------------------------------------------
assign waddr_ram = wptr_bin[ADDR_WIDTH-1:0];
assign raddr_ram = rptr_bin[ADDR_WIDTH-1:0];

// Write enable RAM only if writing and FIFO not full
assign wenc_ram = winc && !wfull;
// Read enable RAM only if reading and FIFO not empty
assign renc_ram = rinc && !rempty;

// Output data directly from RAM read port
assign rdata = rdata_ram;

endmodule
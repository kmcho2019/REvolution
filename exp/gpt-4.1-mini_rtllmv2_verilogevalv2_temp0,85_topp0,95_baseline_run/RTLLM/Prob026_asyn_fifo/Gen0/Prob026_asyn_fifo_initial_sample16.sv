module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input               wclk,
    input               rclk,
    input               wrstn,
    input               rrstn,
    input               winc,
    input               rinc,
    input  [WIDTH-1:0]  wdata,
    output              wfull,
    output              rempty,
    output [WIDTH-1:0]  rdata
);

// Derived parameters
localparam ADDR_WIDTH = $clog2(DEPTH);
localparam PTR_WIDTH = ADDR_WIDTH + 1; // For Gray code pointer with extra bit

//-----------------------------------
// Dual-port RAM module declaration
//-----------------------------------
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr_bin),
    .rdata(rdata)
);

//-----------------------------
// Binary pointers for write/read
//-----------------------------
reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
reg [PTR_WIDTH-1:0] wptr_bin_next, rptr_bin_next;

//-----------------------------
// Gray code pointers
//-----------------------------
reg [PTR_WIDTH-1:0] wptr_gray, rptr_gray;

//----------------------------------------------
// Synchronizers for pointers crossing clock domains
//----------------------------------------------

// Read pointer synchronized into write clock domain (for full generation)
reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk;

// Write pointer synchronized into read clock domain (for empty generation)
reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk;

//----------------------------------------------
// Write enable and read enable signals for RAM
//----------------------------------------------
wire wen, ren;

//----------------------------------------------
// Address for RAM (binary pointers lower bits)
//----------------------------------------------
wire [ADDR_WIDTH-1:0] waddr_bin;
wire [ADDR_WIDTH-1:0] raddr_bin;

assign waddr_bin = wptr_bin[ADDR_WIDTH-1:0];
assign raddr_bin = rptr_bin[ADDR_WIDTH-1:0];

//----------------------------------------------
// Gray code functions
//----------------------------------------------
function [PTR_WIDTH-1:0] bin2gray;
    input [PTR_WIDTH-1:0] bin;
    integer i;
    begin
        // MSB is same
        bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
        for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
            bin2gray[i] = bin[i+1] ^ bin[i];
        end
    end
endfunction

function [PTR_WIDTH-1:0] gray2bin;
    input [PTR_WIDTH-1:0] gray;
    integer i;
    begin
        gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
        for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    end
endfunction

//----------------------------------------------
// Write pointer logic (write clock domain)
//----------------------------------------------
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
    end else begin
        if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end else begin
            wptr_bin <= wptr_bin;
            wptr_gray <= wptr_gray;
        end
    end
end

//----------------------------------------------
// Read pointer logic (read clock domain)
//----------------------------------------------
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
    end else begin
        if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end else begin
            rptr_bin <= rptr_bin;
            rptr_gray <= rptr_gray;
        end
    end
end

//----------------------------------------------
// Synchronize read pointer into write clock domain
//----------------------------------------------
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        rptr_gray_sync1_wclk <= 0;
        rptr_gray_sync2_wclk <= 0;
    end else begin
        rptr_gray_sync1_wclk <= rptr_gray;
        rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
    end
end

//----------------------------------------------
// Synchronize write pointer into read clock domain
//----------------------------------------------
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_gray_sync1_rclk <= 0;
        wptr_gray_sync2_rclk <= 0;
    end else begin
        wptr_gray_sync1_rclk <= wptr_gray;
        wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
    end
end

//----------------------------------------------
// Convert synchronized Gray pointers back to binary
//----------------------------------------------
wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk;
wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk;

assign rptr_bin_sync_wclk = gray2bin(rptr_gray_sync2_wclk);
assign wptr_bin_sync_rclk = gray2bin(wptr_gray_sync2_rclk);

//----------------------------------------------
// FIFO full logic (write clock domain)
// Full when:
// wptr_gray == {~rptr_gray_sync2_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync2_wclk[PTR_WIDTH-3:0]}
// i.e. the MSB and the next MSB of write pointer are inverted compared to read pointer, rest equal
//----------------------------------------------
assign wfull = (wptr_gray == {~rptr_gray_sync2_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync2_wclk[PTR_WIDTH-3:0]});

//----------------------------------------------
// FIFO empty logic (read clock domain)
// Empty when read pointer equals synchronized write pointer
//----------------------------------------------
assign rempty = (rptr_gray == wptr_gray_sync2_rclk);

//----------------------------------------------
// Write enable (RAM write enable) and Read enable (RAM read enable)
// Write only if winc and not full
// Read only if rinc and not empty
//----------------------------------------------
assign wen = winc && !wfull;
assign ren = rinc && !rempty;

endmodule


//-----------------------------
// Dual-port RAM implementation
//-----------------------------
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

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

// Write operation
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end else begin
        rdata <= rdata; // Hold last data if no read enable
    end
end

endmodule
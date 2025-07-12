`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,  // active low write reset
    input                 rrstn,  // active low read reset
    input                 winc,
    input                 rinc,
    input  [WIDTH-1:0]    wdata,
    output                wfull,
    output                rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary and Gray pointers
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;

    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;

    // Synchronizers for pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_0 = 0, rptr_gray_wclk_1 = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_0 = 0, wptr_gray_rclk_1 = 0;

    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk = rptr_gray_wclk_1;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk = wptr_gray_rclk_1;

    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i=i-1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to binary conversion
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer logic (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
        end
    end

    // Read pointer logic (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
        end
    end

    // Synchronize read pointer to write clock domain (2-flip flop synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_0 <= 0;
            rptr_gray_wclk_1 <= 0;
        end else begin
            rptr_gray_wclk_0 <= rptr_gray;
            rptr_gray_wclk_1 <= rptr_gray_wclk_0;
        end
    end

    // Synchronize write pointer to read clock domain (2-flip flop synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_0 <= 0;
            wptr_gray_rclk_1 <= 0;
        end else begin
            wptr_gray_rclk_0 <= wptr_gray;
            wptr_gray_rclk_1 <= wptr_gray_rclk_0;
        end
    end

    // Address for RAM are lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Full when write pointer is one ahead of read pointer with MSB bits inverted
    wire full_condition = (wptr_gray[PTR_WIDTH-1]     != rptr_gray_sync_wclk[PTR_WIDTH-1]) &&
                          (wptr_gray[PTR_WIDTH-2]     != rptr_gray_sync_wclk[PTR_WIDTH-2]) &&
                          (wptr_gray[PTR_WIDTH-3:0]  == rptr_gray_sync_wclk[PTR_WIDTH-3:0]);

    assign wfull = full_condition;

    // Empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    wire [WIDTH-1:0] ram_rdata;

    // Dual-port RAM instance
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

    // Register output data at read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

endmodule

// Dual-port RAM submodule
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

    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule
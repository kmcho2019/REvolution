`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input                  wclk,
    input                  wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]     wdata,
    input                  rclk,
    input                  renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    // Memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
    end
endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wclk,
    input  rclk,
    input  wrstn,
    input  rrstn,
    input  winc,
    input  rinc,
    input  [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);  // Number of bits for addressing DEPTH locations

    // Use PTR_WIDTH+1 bits for pointers to detect full/empty conditions including wrap-around bit
    reg [PTR_WIDTH:0] waddr_bin, raddr_bin;   // Binary pointers
    reg [PTR_WIDTH:0] wptr_gray, rptr_gray;   // Gray-coded pointers

    // Synchronizers (2-stage) for crossing clock domains
    reg [PTR_WIDTH:0] rptr_gray_wclk_1, rptr_gray_wclk_2;
    reg [PTR_WIDTH:0] wptr_gray_rclk_1, wptr_gray_rclk_2;

    // Synchronized pointers
    wire [PTR_WIDTH:0] rptr_gray_sync_wclk = rptr_gray_wclk_2;
    wire [PTR_WIDTH:0] wptr_gray_sync_rclk = wptr_gray_rclk_2;

    // RAM addresses are lower bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr_ram = waddr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr_ram = raddr_bin[PTR_WIDTH-1:0];

    // Write and read enables for RAM
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // RAM read data
    wire [WIDTH-1:0] ram_rdata;

    // Gray code conversion: binary to gray
    function automatic [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        // Gray = binary ^ (binary >> 1)
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Gray code to binary conversion
    function automatic [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i -1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer binary increment and Gray code update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin  <= 0;
            wptr_gray  <= 0;
        end else if (wen) begin
            waddr_bin  <= waddr_bin + 1;
            wptr_gray  <= bin2gray(waddr_bin + 1);
        end
    end

    // Read pointer binary increment and Gray code update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            raddr_bin <= raddr_bin + 1;
            rptr_gray <= bin2gray(raddr_bin + 1);
        end
    end

    // Synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_1 <= 0;
            rptr_gray_wclk_2 <= 0;
        end else begin
            rptr_gray_wclk_1 <= rptr_gray;
            rptr_gray_wclk_2 <= rptr_gray_wclk_1;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_1 <= 0;
            wptr_gray_rclk_2 <= 0;
        end else begin
            wptr_gray_rclk_1 <= wptr_gray;
            wptr_gray_rclk_2 <= wptr_gray_rclk_1;
        end
    end

    // Full flag: compare write pointer to read pointer synchronized into write clock domain
    // Full when: wptr_gray == {~rptr_gray_sync_wclk[PTR_WIDTH:PTR_WIDTH-1], rptr_gray_sync_wclk[PTR_WIDTH-2:0]}
    wire [PTR_WIDTH:0] rptr_gray_inv_msb;
    assign rptr_gray_inv_msb = {~rptr_gray_sync_wclk[PTR_WIDTH], ~rptr_gray_sync_wclk[PTR_WIDTH-1], rptr_gray_sync_wclk[PTR_WIDTH-2:0]};

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= (wptr_gray == rptr_gray_inv_msb);
    end

    // Empty flag: compare read pointer to write pointer synchronized into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= (rptr_gray == wptr_gray_sync_rclk);
    end

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_ram),
        .rdata(ram_rdata)
    );

    assign rdata = ram_rdata;

endmodule
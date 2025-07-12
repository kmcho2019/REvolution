`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input                      wclk,
    input                      wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]         wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read port
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
    output wire wfull,
    output wire rempty,
    output wire [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH); // Number of bits for address

    // Binary pointers (PTR_WIDTH+1 bits to detect wrap-around)
    reg [PTR_WIDTH:0] waddr_bin;
    reg [PTR_WIDTH:0] raddr_bin;

    // Gray code conversion (combinational)
    wire [PTR_WIDTH:0] wptr_gray = (waddr_bin) ^ (waddr_bin >> 1);
    wire [PTR_WIDTH:0] rptr_gray = (raddr_bin) ^ (raddr_bin >> 1);

    // Two-stage synchronizers for crossing domains
    reg [PTR_WIDTH:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    reg [PTR_WIDTH:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    // Synchronize read pointer (Gray) into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer (Gray) into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Binary to Gray conversion functions (combinational)
    function automatic [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Gray to binary conversion function
    function automatic [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Convert synchronized Gray pointers to binary for comparison
    wire [PTR_WIDTH:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_WIDTH:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk_sync);

    // Write pointer increment (write domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
        end else if (winc && !wfull) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Read pointer increment (read domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
        end else if (rinc && !rempty) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Extract RAM addresses (lower PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr_ram = waddr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr_ram = raddr_bin[PTR_WIDTH-1:0];

    // Control RAM read and write enables
    wire wen = (winc && !wfull);
    wire ren = (rinc && !rempty);

    // Instantiate dual-port RAM
    wire [WIDTH-1:0] ram_rdata;
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) u_ram (
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

    // Empty condition: read pointer equals synchronized write pointer in read clock domain
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

    // Full condition: write pointer is one ahead of read pointer considering wrap-around
    // Detect full when: wptr_gray == {~rptr_gray_sync[PTR_WIDTH], ~rptr_gray_sync[PTR_WIDTH-1], rptr_gray_sync[PTR_WIDTH-2:0]}
    wire [PTR_WIDTH:0] rptr_inv_msb = {~rptr_gray_wclk_sync[PTR_WIDTH], ~rptr_gray_wclk_sync[PTR_WIDTH-1], rptr_gray_wclk_sync[PTR_WIDTH-2:0]};
    assign wfull = (wptr_gray == rptr_inv_msb);

endmodule
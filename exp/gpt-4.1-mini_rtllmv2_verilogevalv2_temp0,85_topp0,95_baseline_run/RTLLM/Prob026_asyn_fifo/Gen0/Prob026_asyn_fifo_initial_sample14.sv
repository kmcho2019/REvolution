`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input                    wclk,
    input                    wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]       wdata,
    input                    rclk,
    input                    renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]   rdata
);

    // RAM memory array
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
            rdata <= rdata; // Hold data if not reading
        end
    end

endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,
    input                    rclk,
    input                    wrstn,
    input                    rrstn,
    input                    winc,
    input                    rinc,
    input  [WIDTH-1:0]       wdata,
    output                   wfull,
    output                   rempty,
    output [WIDTH-1:0]       rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH); // Pointer width in bits

    // -------------------
    // Gray code functions
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    // -------------------
    // Write pointer binary and gray
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] wptr; // Gray coded write pointer

    // -------------------
    // Read pointer binary and gray
    reg [PTR_WIDTH-1:0] raddr_bin;
    reg [PTR_WIDTH-1:0] rptr; // Gray coded read pointer

    // -------------------
    // Synchronizers for read pointer into write clock domain
    reg [PTR_WIDTH-1:0] rptr_wclk_sync_0;
    reg [PTR_WIDTH-1:0] rptr_wclk_sync_1;

    // Synchronizers for write pointer into read clock domain
    reg [PTR_WIDTH-1:0] wptr_rclk_sync_0;
    reg [PTR_WIDTH-1:0] wptr_rclk_sync_1;

    // -------------------
    // Extract binary pointers after synchronization
    wire [PTR_WIDTH-1:0] rptr_wclk_bin;
    wire [PTR_WIDTH-1:0] wptr_rclk_bin;

    assign rptr_wclk_bin = gray2bin(rptr_wclk_sync_1);
    assign wptr_rclk_bin = gray2bin(wptr_rclk_sync_1);

    // -------------------
    // Write full logic
    // FIFO is full if:
    // wptr_gray == {~rptr_gray[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]}
    wire full_flag;
    assign full_flag = (wptr == {~rptr_wclk_sync_1[PTR_WIDTH-1:PTR_WIDTH-2], rptr_wclk_sync_1[PTR_WIDTH-3:0]});

    assign wfull = full_flag;

    // -------------------
    // Read empty logic
    // FIFO is empty if:
    // rptr_gray == wptr_gray synchronized to read clock domain
    wire empty_flag;
    assign empty_flag = (rptr == wptr_rclk_sync_1);

    assign rempty = empty_flag;

    // -------------------
    // Write address for RAM access (binary pointer lower bits)
    wire [PTR_WIDTH-1:0] waddr_ram = waddr_bin[PTR_WIDTH-1:0];
    // Read address for RAM access (binary pointer lower bits)
    wire [PTR_WIDTH-1:0] raddr_ram = raddr_bin[PTR_WIDTH-1:0];

    // -------------------
    // Write enable and read enable for RAM
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // -------------------
    // Instantiate dual-port RAM
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr_ram),
        .rdata(rdata)
    );

    // -------------------
    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            rptr_wclk_sync_0 <= 0;
            rptr_wclk_sync_1 <= 0;
        end else begin
            // Increment write pointer if write enable
            if (w_en) begin
                waddr_bin <= waddr_bin + 1'b1;
                wptr <= bin2gray(waddr_bin + 1'b1);
            end else begin
                waddr_bin <= waddr_bin;
                wptr <= wptr;
            end
            // Synchronize read pointer to write clock domain
            rptr_wclk_sync_0 <= rptr;
            rptr_wclk_sync_1 <= rptr_wclk_sync_0;
        end
    end

    // -------------------
    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            wptr_rclk_sync_0 <= 0;
            wptr_rclk_sync_1 <= 0;
        end else begin
            // Increment read pointer if read enable
            if (r_en) begin
                raddr_bin <= raddr_bin + 1'b1;
                rptr <= bin2gray(raddr_bin + 1'b1);
            end else begin
                raddr_bin <= raddr_bin;
                rptr <= rptr;
            end
            // Synchronize write pointer to read clock domain
            wptr_rclk_sync_0 <= wptr;
            wptr_rclk_sync_1 <= wptr_rclk_sync_0;
        end
    end

endmodule
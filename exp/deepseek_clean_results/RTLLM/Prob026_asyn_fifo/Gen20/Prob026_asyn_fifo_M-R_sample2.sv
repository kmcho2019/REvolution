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

    // Parameter validation
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary to Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire wen = winc && !wfull;

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire ren = rinc && !rempty;

    // Memory instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .waddr(waddr),
        .wdata(wdata),
        .wen(wen),
        .rclk(rclk),
        .raddr(raddr),
        .ren(ren),
        .rdata(rdata)
    );

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            if (wen) begin
                wptr_bin <= wptr_bin + 1;
                wptr_gray <= bin2gray(wptr_bin + 1);
            end
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            if (ren) begin
                rptr_bin <= rptr_bin + 1;
                rptr_gray <= bin2gray(rptr_bin + 1);
            end
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Full/empty detection using continuous assignments
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin + 1);
    wire [PTR_WIDTH-1:0] rptr_gray_next = bin2gray(rptr_bin + 1);

    assign wfull = (wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2],
                                 rptr_gray_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync2);

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input wen,
    input rclk,
    input [$clog2(DEPTH)-1:0] raddr,
    input ren,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (ren) rdata <= mem[raddr];
    end

endmodule
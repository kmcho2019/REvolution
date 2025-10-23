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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary to Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;

    // Write pointer update
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            if (wen) wptr_bin <= wptr_bin + 1;
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Full detection
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                   rptr_sync2[PTR_WIDTH-3:0]});

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;

    // Read pointer update
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
            rempty <= 1;
        end else begin
            if (ren) rptr_bin <= rptr_bin + 1;
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
            rempty <= (rptr_gray == wptr_sync2);
        end
    end

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];

endmodule
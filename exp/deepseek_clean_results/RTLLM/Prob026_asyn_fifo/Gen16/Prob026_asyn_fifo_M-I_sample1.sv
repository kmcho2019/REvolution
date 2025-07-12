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

    // Validate parameters
    initial begin
        if (DEPTH < 2) begin
            $error("DEPTH must be at least 2");
            $finish;
        end
        if (WIDTH < 1) begin
            $error("WIDTH must be at least 1");
            $finish;
        end
    end

    // Calculate required widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Simplified Gray code conversion
    function [PTR_WIDTH-1:0] bin_to_gray;
        input [PTR_WIDTH-1:0] bin;
        bin_to_gray = bin ^ (bin >> 1);
    endfunction

    // RAM interface signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Instantiate dual-port RAM
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

    // Write domain logic
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1 = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync2 = 0;

    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            // Two-stage synchronizer
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
            
            if (wen) begin
                wptr_bin <= wptr_bin + 1;
                wptr_gray <= bin_to_gray(wptr_bin + 1);
            end
        end
    end

    // Read domain logic
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync1 = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync2 = 0;

    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            // Two-stage synchronizer
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
            
            if (ren) begin
                rptr_bin <= rptr_bin + 1;
                rptr_gray <= bin_to_gray(rptr_bin + 1);
            end
        end
    end

    // Full/empty detection with optimized logic
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin_to_gray(wptr_bin + 1);
    assign wfull = (wptr_gray_next == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                     rptr_gray_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync2);

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

    // Packed array for better PPA
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule
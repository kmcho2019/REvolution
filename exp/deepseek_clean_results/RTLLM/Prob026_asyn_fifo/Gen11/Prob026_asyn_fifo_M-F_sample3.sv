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
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("Error: DEPTH must be a power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        return (bin >> 1) ^ bin;
    endfunction

    // RAM interface signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Dual-port RAM instance
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

    // =============================================
    // Write Clock Domain
    // =============================================
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;

    // Binary write pointer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
        end
    end

    // Gray code conversion for write pointer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_gray <= 0;
        end else begin
            wptr_gray <= bin2gray(wptr_bin);
        end
    end

    // Read pointer synchronization (2-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync2, rptr_sync1} <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // =============================================
    // Read Clock Domain
    // =============================================
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;

    // Binary read pointer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

    // Gray code conversion for read pointer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_gray <= 0;
        end else begin
            rptr_gray <= bin2gray(rptr_bin);
        end
    end

    // Write pointer synchronization (2-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync2, wptr_sync1} <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // =============================================
    // Full/Empty Detection
    // =============================================
    // Full condition: MSBs differ, rest same
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync2[PTR_WIDTH-3:0]});
    
    // Empty condition: pointers equal
    assign rempty = (rptr_gray == wptr_sync2);

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

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
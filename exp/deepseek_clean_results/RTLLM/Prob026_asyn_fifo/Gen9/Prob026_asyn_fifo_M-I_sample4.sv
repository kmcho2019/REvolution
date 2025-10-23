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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
    wire wen = winc && !wfull;

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];
    wire ren = rinc && !rempty;

    // Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Full/empty detection
    always @(*) begin
        wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                              rptr_sync2[PTR_WIDTH-3:0]});
        rempty = (rptr_gray == wptr_sync2);
    end

    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            // Pointer update
            if (wen) begin
                wptr <= wptr + 1;
                wptr_gray <= wptr_gray ^ ((wptr + 1) ^ wptr) >> 1; // Efficient Gray update
            end
            
            // Read pointer synchronization
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
            rdata <= 0;
        end else begin
            // Pointer update
            if (ren) begin
                rptr <= rptr + 1;
                rptr_gray <= rptr_gray ^ ((rptr + 1) ^ rptr) >> 1; // Efficient Gray update
            end
            
            // Write pointer synchronization
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
            
            // Memory read
            if (ren) rdata <= mem[raddr];
        end
    end

    // Memory write
    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end

endmodule
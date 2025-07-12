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

    // Gray code conversion functions
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync2);

    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
            {rptr_sync2, rptr_sync1} <= 0;
        end else begin
            // Pointer update
            if (wen) begin
                wptr <= wptr + 1;
                wptr_gray <= bin2gray(wptr + 1);
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
            {wptr_sync2, wptr_sync1} <= 0;
        end else begin
            // Pointer update
            if (ren) begin
                rptr <= rptr + 1;
                rptr_gray <= bin2gray(rptr + 1);
            end
            
            // Write pointer synchronization
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Memory operations
    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    always @(posedge rclk) if (ren) rdata <= mem[raddr];

endmodule
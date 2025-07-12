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
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 0;
    end

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    
    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Write control
    wire wen = winc && !wfull;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + wen;
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            if (wen) begin
                mem[waddr] <= wdata;
                wptr_bin <= wptr_bin_next;
                wptr_gray <= wptr_gray_next;
            end
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end
    
    // Read control
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + ren;
    wire [PTR_WIDTH-1:0] rptr_gray_next = bin2gray(rptr_bin_next);
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rdata <= 0;
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            if (ren) begin
                rdata <= mem[raddr];
                rptr_bin <= rptr_bin_next;
                rptr_gray <= rptr_gray_next;
            end
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end
    
    // Full/empty generation
    assign wfull = (wptr_gray_next == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                      rptr_sync2[PTR_WIDTH-3:0]});
    
    assign rempty = (rptr_gray == wptr_sync2);

endmodule
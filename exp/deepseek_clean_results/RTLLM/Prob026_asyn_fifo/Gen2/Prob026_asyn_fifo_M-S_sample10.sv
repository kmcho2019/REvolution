module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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
    
    // RAM signals
    wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];
    
    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write port
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[waddr] <= wdata;
    end
    
    // Read port
    always @(posedge rclk) begin
        if (rinc && !rempty)
            rdata <= mem[raddr];
    end

    // Pointers (Gray coded)
    reg [ADDR_WIDTH:0] wptr, rptr;
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;
    
    // Binary to Gray conversion
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (winc && !wfull) begin
            wptr <= bin2gray(wptr + 1);
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else if (rinc && !rempty) begin
            rptr <= bin2gray(rptr + 1);
        end
    end
    
    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync1, rptr_sync2} <= 0;
        else {rptr_sync1, rptr_sync2} <= {rptr, rptr_sync1};
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync1, wptr_sync2} <= 0;
        else {wptr_sync1, wptr_sync2} <= {wptr, wptr_sync1};
    end
    
    // Full/empty detection
    assign wfull = (wptr == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                            rptr_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr == wptr_sync2);

endmodule
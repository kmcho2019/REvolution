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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Pointers (Gray coded)
    reg [ADDR_WIDTH:0] wptr, rptr;
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;
    
    // Binary to Gray conversion
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (winc && !wfull) begin
            wptr <= bin2gray(wptr + 1);
        end
    end
    
    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else if (rinc && !rempty) begin
            rptr <= bin2gray(rptr + 1);
        end
    end
    
    // Pointer synchronization (write to read)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync1, wptr_sync2} <= 0;
        end else begin
            wptr_sync1 <= wptr;
            wptr_sync2 <= wptr_sync1;
        end
    end
    
    // Pointer synchronization (read to write)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync1, rptr_sync2} <= 0;
        end else begin
            rptr_sync1 <= rptr;
            rptr_sync2 <= rptr_sync1;
        end
    end
    
    // Full/empty detection
    always @(*) begin
        // Full when Gray(wptr) == Gray(~rptr_sync2)
        wfull = (wptr == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                         rptr_sync2[ADDR_WIDTH-2:0]});
        // Empty when pointers match
        rempty = (rptr == wptr_sync2);
    end
    
    // Write operation
    always @(posedge wclk) begin
        if (winc && !wfull) begin
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Read operation
    always @(posedge rclk) begin
        if (rinc && !rempty) begin
            rdata <= mem[rptr[ADDR_WIDTH-1:0]];
        end
    end

endmodule
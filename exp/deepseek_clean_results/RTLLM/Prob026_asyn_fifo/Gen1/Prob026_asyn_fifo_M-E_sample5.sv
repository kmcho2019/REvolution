module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    // Write interface
    input wire wclk,
    input wire wrstn,
    input wire winc,
    input wire [WIDTH-1:0] wdata,
    output wire wfull,
    
    // Read interface
    input wire rclk,
    input wire rrstn,
    input wire rinc,
    output wire [WIDTH-1:0] rdata,
    output wire rempty
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr = 0;
    reg [PTR_WIDTH-1:0] wptr_sent = 0;
    reg [PTR_WIDTH-1:0] rptr_synced = 0;
    reg wptr_valid = 0;
    reg wptr_ack = 0;
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr = 0;
    reg [PTR_WIDTH-1:0] rptr_sent = 0;
    reg [PTR_WIDTH-1:0] wptr_synced = 0;
    reg rptr_valid = 0;
    reg rptr_ack = 0;
    
    // Synchronizers
    reg [PTR_WIDTH-1:0] wptr_sync_ff1, wptr_sync_ff2;
    reg [PTR_WIDTH-1:0] rptr_sync_ff1, rptr_sync_ff2;
    reg wvalid_sync_ff1, wvalid_sync_ff2;
    reg rvalid_sync_ff1, rvalid_sync_ff2;
    
    // Control signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    
    // Address calculation
    wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];
    
    // Full/empty detection
    wire [PTR_WIDTH-1:0] wptr_diff = wptr - rptr_synced;
    wire [PTR_WIDTH-1:0] rptr_diff = wptr_synced - rptr;
    assign wfull = (wptr_diff >= DEPTH);
    assign rempty = (rptr_diff == 0);
    
    // Write domain logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_sent <= 0;
            wptr_valid <= 0;
            wptr_ack <= 0;
        end else begin
            // Pointer update
            if (wen) begin
                mem[waddr] <= wdata;
                wptr <= wptr + 1;
            end
            
            // Pointer synchronization handshake
            if (wptr != wptr_sent && !wptr_valid) begin
                wptr_sent <= wptr;
                wptr_valid <= 1;
            end
            
            if (rvalid_sync_ff2 && !wptr_ack) begin
                rptr_synced <= rptr_sync_ff2;
                wptr_ack <= 1;
            end
            
            if (!rvalid_sync_ff2 && wptr_ack) begin
                wptr_ack <= 0;
            end
            
            if (wptr_valid && wptr_ack) begin
                wptr_valid <= 0;
            end
        end
    end
    
    // Read domain logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_sent <= 0;
            rptr_valid <= 0;
            rptr_ack <= 0;
            rdata <= 0;
        end else begin
            // Pointer update
            if (ren) begin
                rdata <= mem[raddr];
                rptr <= rptr + 1;
            end
            
            // Pointer synchronization handshake
            if (rptr != rptr_sent && !rptr_valid) begin
                rptr_sent <= rptr;
                rptr_valid <= 1;
            end
            
            if (wvalid_sync_ff2 && !rptr_ack) begin
                wptr_synced <= wptr_sync_ff2;
                rptr_ack <= 1;
            end
            
            if (!wvalid_sync_ff2 && rptr_ack) begin
                rptr_ack <= 0;
            end
            
            if (rptr_valid && rptr_ack) begin
                rptr_valid <= 0;
            end
        end
    end
    
    // Write pointer synchronization to read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync_ff1 <= 0;
            wptr_sync_ff2 <= 0;
            wvalid_sync_ff1 <= 0;
            wvalid_sync_ff2 <= 0;
        end else begin
            wptr_sync_ff1 <= wptr_sent;
            wptr_sync_ff2 <= wptr_sync_ff1;
            wvalid_sync_ff1 <= wptr_valid;
            wvalid_sync_ff2 <= wvalid_sync_ff1;
        end
    end
    
    // Read pointer synchronization to write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync_ff1 <= 0;
            rptr_sync_ff2 <= 0;
            rvalid_sync_ff1 <= 0;
            rvalid_sync_ff2 <= 0;
        end else begin
            rptr_sync_ff1 <= rptr_sent;
            rptr_sync_ff2 <= rptr_sync_ff1;
            rvalid_sync_ff1 <= rptr_valid;
            rvalid_sync_ff2 <= rvalid_sync_ff1;
        end
    end

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ALMOST_FULL = DEPTH-2,
    parameter ALMOST_EMPTY = 2
)(
    // Write interface
    input wire wclk,
    input wire wrstn,
    input wire winc,
    input wire [WIDTH-1:0] wdata,
    output wire wfull,
    output wire w_almost_full,
    
    // Read interface
    input wire rclk,
    input wire rrstn,
    input wire rinc,
    output wire [WIDTH-1:0] rdata,
    output wire rempty,
    output wire r_almost_empty,
    
    // Error detection
    output wire sync_error
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [ADDR_WIDTH:0] wptr;
    reg [ADDR_WIDTH:0] wptr_gray;
    reg w_ack;
    reg w_req;
    reg [ADDR_WIDTH:0] rptr_sync;
    
    // Read domain signals
    reg [ADDR_WIDTH:0] rptr;
    reg [ADDR_WIDTH:0] rptr_gray;
    reg r_ack;
    reg r_req;
    reg [ADDR_WIDTH:0] wptr_sync;
    
    // Handshake synchronization
    reg [1:0] w2r_sync;
    reg [1:0] r2w_sync;
    
    // Error detection
    reg sync_error_w;
    reg sync_error_r;
    
    // Pointer difference
    wire [ADDR_WIDTH:0] wptr_diff = wptr - rptr_sync;
    wire [ADDR_WIDTH:0] rptr_diff = wptr_sync - rptr;
    
    // Control signals
    assign wfull = (wptr_diff == DEPTH);
    assign rempty = (rptr_diff == 0);
    assign w_almost_full = (wptr_diff >= ALMOST_FULL);
    assign r_almost_empty = (rptr_diff <= ALMOST_EMPTY);
    assign sync_error = sync_error_w | sync_error_r;
    
    // Data paths
    assign rdata = mem[rptr[ADDR_WIDTH-1:0]];
    
    // Write pointer management
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            w_req <= 0;
            w_ack <= 0;
            sync_error_w <= 0;
        end else begin
            // Pointer update
            if (winc && !wfull) begin
                mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
                wptr <= wptr + 1;
            end
            
            // Handshake protocol
            if (w_req == r_ack) begin
                w_req <= ~w_req;
            end
            
            // Error detection
            if (w2r_sync[1] ^ w2r_sync[0]) begin
                sync_error_w <= 1;
            end
        end
    end
    
    // Read pointer management
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            r_req <= 0;
            r_ack <= 0;
            sync_error_r <= 0;
        end else begin
            // Pointer update
            if (rinc && !rempty) begin
                rptr <= rptr + 1;
            end
            
            // Handshake protocol
            if (r_req == w_ack) begin
                r_req <= ~r_req;
            end
            
            // Error detection
            if (r2w_sync[1] ^ r2w_sync[0]) begin
                sync_error_r <= 1;
            end
        end
    end
    
    // Write to read synchronization
    always @(posedge rclk) begin
        w2r_sync <= {w2r_sync[0], w_req};
        if (w2r_sync[1] != w2r_sync[0]) begin
            rptr_sync <= wptr;
            w_ack <= w2r_sync[1];
        end
    end
    
    // Read to write synchronization
    always @(posedge wclk) begin
        r2w_sync <= {r2w_sync[0], r_req};
        if (r2w_sync[1] != r2w_sync[0]) begin
            wptr_sync <= rptr;
            r_ack <= r2w_sync[1];
        end
    end

endmodule
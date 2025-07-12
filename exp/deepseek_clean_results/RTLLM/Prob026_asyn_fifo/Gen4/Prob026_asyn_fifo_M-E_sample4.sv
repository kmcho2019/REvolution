module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SEG_BITS = 2,  // Number of bits for coarse segment
    parameter PREDICT_DEPTH = 2  // History depth for prediction
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
    output [WIDTH-1:0] rdata
);

    // Calculate address widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam FINE_WIDTH = ADDR_WIDTH - SEG_BITS;
    
    // RAM interface
    wire wenc;
    wire [ADDR_WIDTH-1:0] waddr;
    wire renc;
    wire [ADDR_WIDTH-1:0] raddr;

    // Dual-port RAM instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain
    reg [ADDR_WIDTH:0] wptr_bin = 0;
    reg [SEG_BITS:0] wptr_coarse = 0;
    reg [FINE_WIDTH-1:0] wptr_fine = 0;
    reg [1:0] wptr_sync_req = 0;
    reg [PREDICT_DEPTH-1:0] w_hist = 0;

    // Read domain
    reg [ADDR_WIDTH:0] rptr_bin = 0;
    reg [SEG_BITS:0] rptr_coarse = 0;
    reg [FINE_WIDTH-1:0] rptr_fine = 0;
    reg [1:0] rptr_sync_req = 0;
    reg [PREDICT_DEPTH-1:0] r_hist = 0;

    // Synchronized pointers
    reg [SEG_BITS:0] sync_rptr_coarse = 0;
    reg [SEG_BITS:0] sync_wptr_coarse = 0;

    // Threshold registers
    reg [ADDR_WIDTH:0] full_thresh = DEPTH - 1;
    reg [ADDR_WIDTH:0] empty_thresh = 1;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_coarse <= 0;
            wptr_fine <= 0;
            w_hist <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_bin + 1;
            {wptr_coarse, wptr_fine} <= wptr_bin + 1;
            w_hist <= {w_hist[PREDICT_DEPTH-2:0], winc};
            
            // Coarse sync trigger
            if (&wptr_fine) wptr_sync_req <= ~wptr_sync_req;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_coarse <= 0;
            rptr_fine <= 0;
            r_hist <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_bin + 1;
            {rptr_coarse, rptr_fine} <= rptr_bin + 1;
            r_hist <= {r_hist[PREDICT_DEPTH-2:0], rinc};
            
            // Coarse sync trigger
            if (&rptr_fine) rptr_sync_req <= ~rptr_sync_req;
        end
    end

    // Coarse pointer synchronization (handshake)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            sync_rptr_coarse <= 0;
        end else begin
            if (wptr_sync_req[0] != wptr_sync_req[1]) begin
                sync_rptr_coarse <= rptr_coarse;
            end
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            sync_wptr_coarse <= 0;
        end else begin
            if (rptr_sync_req[0] != rptr_sync_req[1]) begin
                sync_wptr_coarse <= wptr_coarse;
            end
        end
    end

    // Threshold adaptation
    always @(posedge wclk) begin
        if (w_hist == {PREDICT_DEPTH{1'b1}}) begin
            full_thresh <= full_thresh - 1;
        end else if (w_hist == 0) begin
            full_thresh <= full_thresh + 1;
        end
    end

    always @(posedge rclk) begin
        if (r_hist == {PREDICT_DEPTH{1'b1}}) begin
            empty_thresh <= empty_thresh + 1;
        end else if (r_hist == 0) begin
            empty_thresh <= empty_thresh - 1;
        end
    end

    // Predictive full/empty detection
    always @(posedge wclk) begin
        wfull <= (wptr_bin - rptr_bin) >= full_thresh;
    end

    always @(posedge rclk) begin
        rempty <= (wptr_bin - rptr_bin) <= empty_thresh;
    end

    // Control signals
    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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

    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule
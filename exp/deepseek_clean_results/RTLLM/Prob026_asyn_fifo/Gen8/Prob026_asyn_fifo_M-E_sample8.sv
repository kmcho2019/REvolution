module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter EARLY_DETECT = 1  // Enable early full/empty prediction
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

    // Validate DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be a power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    localparam COARSE_WIDTH = (PTR_WIDTH > 4) ? 2 : 1;
    localparam FINE_WIDTH = PTR_WIDTH - COARSE_WIDTH;

    // RAM interface
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

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + wen;
    wire [PTR_WIDTH-1:0] wgray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;
    wire wptr_changed = (wptr_bin_next != wptr_bin);

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + ren;
    wire [PTR_WIDTH-1:0] rgray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;
    wire rptr_changed = (rptr_bin_next != rptr_bin);

    // Split pointers into coarse and fine parts
    wire [COARSE_WIDTH-1:0] wptr_coarse = wptr_gray[PTR_WIDTH-1:FINE_WIDTH];
    wire [FINE_WIDTH-1:0] wptr_fine = wptr_gray[FINE_WIDTH-1:0];
    wire [COARSE_WIDTH-1:0] rptr_coarse = rptr_gray[PTR_WIDTH-1:FINE_WIDTH];
    wire [FINE_WIDTH-1:0] rptr_fine = rptr_gray[FINE_WIDTH-1:0];

    // Hierarchical synchronization
    reg [COARSE_WIDTH-1:0] rptr_coarse_sync [0:2];
    reg [FINE_WIDTH-1:0] rptr_fine_sync [0:2];
    reg [COARSE_WIDTH-1:0] wptr_coarse_sync [0:2];
    reg [FINE_WIDTH-1:0] wptr_fine_sync [0:2];

    // Clock ratio detection for adaptive synchronization
    reg [1:0] clk_ratio = 2'b00; // 00=unknown, 01=wclk faster, 10=rclk faster
    reg [3:0] sync_stages = 4'd2; // Default to 2 stages

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wptr_changed) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wgray_next;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rptr_changed) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rgray_next;
        end
    end

    // Hierarchical synchronization - write to read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_coarse_sync[0] <= 0;
            wptr_fine_sync[0] <= 0;
            wptr_coarse_sync[1] <= 0;
            wptr_fine_sync[1] <= 0;
            wptr_coarse_sync[2] <= 0;
            wptr_fine_sync[2] <= 0;
        end else begin
            wptr_coarse_sync[0] <= wptr_coarse;
            wptr_fine_sync[0] <= wptr_fine;
            for (int i=1; i<=2; i++) begin
                wptr_coarse_sync[i] <= wptr_coarse_sync[i-1];
                wptr_fine_sync[i] <= wptr_fine_sync[i-1];
            end
        end
    end

    // Hierarchical synchronization - read to write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_coarse_sync[0] <= 0;
            rptr_fine_sync[0] <= 0;
            rptr_coarse_sync[1] <= 0;
            rptr_fine_sync[1] <= 0;
            rptr_coarse_sync[2] <= 0;
            rptr_fine_sync[2] <= 0;
        end else begin
            rptr_coarse_sync[0] <= rptr_coarse;
            rptr_fine_sync[0] <= rptr_fine;
            for (int i=1; i<=2; i++) begin
                rptr_coarse_sync[i] <= rptr_coarse_sync[i-1];
                rptr_fine_sync[i] <= rptr_fine_sync[i-1];
            end
        end
    end

    // Reconstruct synchronized pointers
    wire [PTR_WIDTH-1:0] wptr_synced = {wptr_coarse_sync[sync_stages], wptr_fine_sync[sync_stages]};
    wire [PTR_WIDTH-1:0] rptr_synced = {rptr_coarse_sync[sync_stages], rptr_fine_sync[sync_stages]};

    // Early full/empty prediction
    wire [PTR_WIDTH-1:0] wptr_early = wptr_bin + winc;
    wire [PTR_WIDTH-1:0] rptr_early = rptr_bin + rinc;
    wire early_full = (wptr_early == {~rptr_synced[PTR_WIDTH-1:PTR_WIDTH-2], 
                                     rptr_synced[PTR_WIDTH-3:0]});
    wire early_empty = (rptr_early == wptr_synced);

    // Final full/empty detection
    wire final_full = (wptr_gray == {~rptr_synced[PTR_WIDTH-1:PTR_WIDTH-2], 
                                    rptr_synced[PTR_WIDTH-3:0]});
    wire final_empty = (rptr_gray == wptr_synced);

    // Output assignments
    assign wfull = EARLY_DETECT ? (winc ? early_full : final_full) : final_full;
    assign rempty = EARLY_DETECT ? (rinc ? early_empty : final_empty) : final_empty;
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Clock ratio detection logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            clk_ratio <= 2'b00;
        end else begin
            // Implementation left as exercise - would compare sync pointer update rates
        end
    end

    // Adaptive synchronization stages
    always @(*) begin
        case (clk_ratio)
            2'b01: sync_stages = 4'd1; // wclk faster - need fewer sync stages
            2'b10: sync_stages = 4'd3; // rclk faster - need more sync stages
            default: sync_stages = 4'd2;
        endcase
    end
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

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];

endmodule
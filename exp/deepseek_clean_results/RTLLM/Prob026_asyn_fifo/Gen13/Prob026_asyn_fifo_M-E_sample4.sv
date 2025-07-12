module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter BANKS = 4  // Must be power of 2 and <= DEPTH
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
        if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");
        if ((BANKS & (BANKS-1)) != 0) $error("BANKS must be power of 2");
        if (BANKS > DEPTH) $error("BANKS cannot exceed DEPTH");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam BANK_ADDR_WIDTH = $clog2(BANKS);
    localparam BANK_DEPTH = DEPTH/BANKS;
    localparam BANK_ADDR_SIZE = $clog2(BANK_DEPTH);
    localparam PTR_WIDTH = BANK_ADDR_SIZE + 1;

    // Bank selection signals
    wire [BANK_ADDR_WIDTH-1:0] wbank_sel = wptr_bin[PTR_WIDTH-1 -: BANK_ADDR_WIDTH];
    wire [BANK_ADDR_WIDTH-1:0] rbank_sel = rptr_bin[PTR_WIDTH-1 -: BANK_ADDR_WIDTH];

    // ===========================================
    // Write Domain Logic
    // ===========================================
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);

    // Bank write enables
    wire [BANKS-1:0] bank_wen;
    generate
        for (genvar i = 0; i < BANKS; i++) begin
            assign bank_wen[i] = winc && !wfull && (wbank_sel == i);
        end
    endgenerate

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // ===========================================
    // Read Domain Logic
    // ===========================================
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);

    // Bank read enables
    wire [BANKS-1:0] bank_ren;
    generate
        for (genvar i = 0; i < BANKS; i++) begin
            assign bank_ren[i] = rinc && !rempty && (rbank_sel == i);
        end
    endgenerate

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
        end
    end

    // ===========================================
    // Bank Synchronization System
    // ===========================================
    wire [PTR_WIDTH-1:0] rptr_synced [0:BANKS-1];
    wire [PTR_WIDTH-1:0] wptr_synced [0:BANKS-1];

    generate
        for (genvar i = 0; i < BANKS; i++) begin
            // Write-side sync for read pointers
            sync_cell #(.WIDTH(PTR_WIDTH)) wr_sync (
                .clk(wclk),
                .rstn(wrstn),
                .d(rptr_gray),
                .q(rptr_synced[i])
            );

            // Read-side sync for write pointers
            sync_cell #(.WIDTH(PTR_WIDTH)) rw_sync (
                .clk(rclk),
                .rstn(rrstn),
                .d(wptr_gray),
                .q(wptr_synced[i])
            );
        end
    endgenerate

    // ===========================================
    // Bank Status Detection
    // ===========================================
    wire [BANKS-1:0] bank_full, bank_empty;

    generate
        for (genvar i = 0; i < BANKS; i++) begin
            // Full detection for each bank
            assign bank_full[i] = (wptr_gray == {~rptr_synced[i][PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_synced[i][PTR_WIDTH-3:0]});

            // Empty detection for each bank
            assign bank_empty[i] = (rptr_gray == wptr_synced[i]);
        end
    endgenerate

    // Global status (OR of all bank status)
    assign wfull = |bank_full;
    assign rempty = &bank_empty;

    // ===========================================
    // Banked Memory System
    // ===========================================
    wire [WIDTH-1:0] bank_rdata [0:BANKS-1];

    generate
        for (genvar i = 0; i < BANKS; i++) begin
            dual_port_ram #(
                .WIDTH(WIDTH),
                .DEPTH(BANK_DEPTH)
            ) bank_ram (
                .wclk(wclk),
                .wenc(bank_wen[i]),
                .waddr(wptr_bin[BANK_ADDR_SIZE-1:0]),
                .wdata(wdata),
                .rclk(rclk),
                .renc(bank_ren[i]),
                .raddr(rptr_bin[BANK_ADDR_SIZE-1:0]),
                .rdata(bank_rdata[i])
            );
        end
    endgenerate

    // Output mux
    assign rdata = bank_rdata[rbank_sel];

endmodule

// Two-stage synchronizer
module sync_cell #(
    parameter WIDTH = 4
) (
    input clk,
    input rstn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    reg [WIDTH-1:0] sync_stage [0:1];

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_stage[0] <= 0;
            sync_stage[1] <= 0;
            q <= 0;
        end else begin
            sync_stage[0] <= d;
            sync_stage[1] <= sync_stage[0];
            q <= sync_stage[1];
        end
    end
endmodule

// Dual-port RAM (same as previous implementation)
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

    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end
endmodule
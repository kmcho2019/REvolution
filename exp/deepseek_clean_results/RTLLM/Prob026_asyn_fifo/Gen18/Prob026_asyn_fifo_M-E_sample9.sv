module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter BANKS = 2
) (
    input wclk,
    input rclk,
    input wrst_n,
    input rrst_n,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata,
    output wire w_almost_full,
    output wire r_almost_empty
);

    // Validate parameters
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");
        if ((BANKS & (BANKS-1)) != 0) $error("BANKS must be power of 2");
        if (DEPTH < BANKS*2) $error("DEPTH must be at least 2*BANKS");
    end

    localparam BANK_DEPTH = DEPTH/BANKS;
    localparam BANK_ADDR = $clog2(BANK_DEPTH);
    localparam PTR_WIDTH = $clog2(DEPTH) + 1;
    localparam COARSE_WIDTH = $clog2(BANKS) + 1;
    localparam FINE_WIDTH = PTR_WIDTH - COARSE_WIDTH;

    // Hierarchical Gray code functions
    function automatic [PTR_WIDTH-1:0] split_gray(input [PTR_WIDTH-1:0] ptr);
        return {ptr[PTR_WIDTH-1:PTR_WIDTH-COARSE_WIDTH], 
                ptr[PTR_WIDTH-COARSE_WIDTH-1:0]};
    endfunction

    function automatic [PTR_WIDTH-1:0] merge_gray(input [COARSE_WIDTH-1:0] coarse,
                                                 input [FINE_WIDTH-1:0] fine);
        return {coarse, fine};
    endfunction

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [COARSE_WIDTH-1:0] wptr_coarse_gray;
    reg [FINE_WIDTH-1:0] wptr_fine_gray;
    reg [COARSE_WIDTH-1:0] rptr_coarse_sync [0:1];
    wire [PTR_WIDTH-1:0] wptr_next_bin = wptr_bin + 1;
    wire wen = winc && !wfull;

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [COARSE_WIDTH-1:0] rptr_coarse_gray;
    reg [FINE_WIDTH-1:0] rptr_fine_gray;
    reg [COARSE_WIDTH-1:0] wptr_coarse_sync [0:1];
    wire [PTR_WIDTH-1:0] rptr_next_bin = rptr_bin + 1;
    wire ren = rinc && !rempty;

    // Banked memory interface
    wire [BANK_ADDR-1:0] wbank_addr [0:BANKS-1];
    wire [BANK_ADDR-1:0] rbank_addr [0:BANKS-1];
    wire [WIDTH-1:0] rdata_bank [0:BANKS-1];
    wire [BANKS-1:0] wbank_sel, rbank_sel;

    // Generate memory banks
    genvar i;
    generate
        for (i=0; i<BANKS; i=i+1) begin : BANK
            // Address hashing
            assign wbank_addr[i] = wptr_bin[BANK_ADDR:1] ^ i;
            assign rbank_addr[i] = rptr_bin[BANK_ADDR:1] ^ i;
            
            // Bank selection
            assign wbank_sel[i] = (wptr_bin[0+:COARSE_WIDTH] == i);
            assign rbank_sel[i] = (rptr_bin[0+:COARSE_WIDTH] == i);
            
            // Memory instance
            bank_mem #(.WIDTH(WIDTH), .DEPTH(BANK_DEPTH)) mem (
                .wclk(wclk),
                .wen(wen & wbank_sel[i]),
                .waddr(wbank_addr[i]),
                .wdata(wdata),
                .rclk(rclk),
                .ren(ren & rbank_sel[i]),
                .raddr(rbank_addr[i]),
                .rdata(rdata_bank[i])
            );
        end
    endgenerate

    // Output data mux
    assign rdata = rdata_bank[rptr_bin[0+:COARSE_WIDTH]];

    // Write pointer update
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wptr_bin <= 0;
            {wptr_coarse_gray, wptr_fine_gray} <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_next_bin;
            {wptr_coarse_gray, wptr_fine_gray} <= split_gray(wptr_next_bin ^ (wptr_next_bin >> 1));
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rptr_bin <= 0;
            {rptr_coarse_gray, rptr_fine_gray} <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_next_bin;
            {rptr_coarse_gray, rptr_fine_gray} <= split_gray(rptr_next_bin ^ (rptr_next_bin >> 1));
        end
    end

    // Coarse pointer synchronization
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            rptr_coarse_sync[0] <= 0;
            rptr_coarse_sync[1] <= 0;
        end else begin
            rptr_coarse_sync[0] <= rptr_coarse_gray;
            rptr_coarse_sync[1] <= rptr_coarse_sync[0];
        end
    end

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            wptr_coarse_sync[0] <= 0;
            wptr_coarse_sync[1] <= 0;
        end else begin
            wptr_coarse_sync[0] <= wptr_coarse_gray;
            wptr_coarse_sync[1] <= wptr_coarse_sync[0];
        end
    end

    // Early status detection
    wire [COARSE_WIDTH-1:0] wptr_coarse_next = wptr_coarse_gray ^ 
                                              ((wptr_fine_gray == {FINE_WIDTH{1'b1}}) ? 
                                               (1 << (COARSE_WIDTH-1)) : 0;
    wire [COARSE_WIDTH-1:0] rptr_coarse_next = rptr_coarse_gray ^ 
                                              ((rptr_fine_gray == {FINE_WIDTH{1'b1}}) ? 
                                               (1 << (COARSE_WIDTH-1)) : 0;

    // Full/empty detection
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wfull <= 0;
        end else begin
            wfull <= (wptr_coarse_next == {~rptr_coarse_sync[1][COARSE_WIDTH-1:COARSE_WIDTH-2],
                                         rptr_coarse_sync[1][COARSE_WIDTH-3:0]}) &&
                    (wptr_fine_gray == {FINE_WIDTH{1'b1}});
        end
    end

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rempty <= 1;
        end else begin
            rempty <= (rptr_coarse_gray == wptr_coarse_sync[1]) &&
                     (rptr_fine_gray == wptr_fine_gray);
        end
    end

    // Almost full/empty indicators
    assign w_almost_full = (wptr_coarse_gray == rptr_coarse_sync[1]) &&
                          (wptr_fine_gray == {FINE_WIDTH{1'b1}});
    assign r_almost_empty = (rptr_coarse_gray == wptr_coarse_sync[1]) &&
                           (rptr_fine_gray == {FINE_WIDTH{1'b0}});

endmodule

// Bank memory module
module bank_mem #(
    parameter WIDTH = 8,
    parameter DEPTH = 8
) (
    input wclk,
    input wen,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input ren,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (ren) rdata <= mem[raddr];
    end

endmodule
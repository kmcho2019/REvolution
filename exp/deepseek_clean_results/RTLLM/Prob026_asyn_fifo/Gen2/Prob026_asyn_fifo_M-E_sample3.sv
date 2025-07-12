module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter INIT_SYNC_STAGES = 2
) (
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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Dual-port RAM
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
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
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_prev = 0;
    reg [3:0] wptr_meta_history = 0;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wptr_gray_prev <= 0;
            wptr_meta_history <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray_prev <= wptr_gray;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
            // Track metastability history
            wptr_meta_history <= {wptr_meta_history[2:0], 
                                (wptr_gray != wptr_gray_prev)};
        end
    end

    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_prev = 0;
    reg [3:0] rptr_meta_history = 0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rptr_gray_prev <= 0;
            rptr_meta_history <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray_prev <= rptr_gray;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
            // Track metastability history
            rptr_meta_history <= {rptr_meta_history[2:0],
                                (rptr_gray != rptr_gray_prev)};
        end
    end

    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Adaptive synchronization
    reg [PTR_WIDTH-1:0] wptr_sync [0:3];
    reg [PTR_WIDTH-1:0] rptr_sync [0:3];
    reg [1:0] sync_stages = INIT_SYNC_STAGES;

    // Dynamic synchronization stage adjustment
    always @(posedge wclk) begin
        case (wptr_meta_history)
            4'b0000: sync_stages <= (sync_stages > 1) ? sync_stages - 1 : 1;
            4'b1111: sync_stages <= (sync_stages < 3) ? sync_stages + 1 : 3;
            default: sync_stages <= sync_stages;
        endcase
    end

    // Sync write pointer to read domain
    always @(posedge rclk) begin
        wptr_sync[0] <= wptr_gray;
        for (int i=1; i<=sync_stages; i=i+1)
            wptr_sync[i] <= wptr_sync[i-1];
    end

    // Sync read pointer to write domain
    always @(posedge wclk) begin
        rptr_sync[0] <= rptr_gray;
        for (int i=1; i<=sync_stages; i=i+1)
            rptr_sync[i] <= rptr_sync[i-1];
    end

    // Adaptive threshold calculation
    reg [PTR_WIDTH-1:0] full_threshold = DEPTH - 1;
    reg [PTR_WIDTH-1:0] empty_threshold = 0;
    reg [15:0] wclk_counter = 0;
    reg [15:0] rclk_counter = 0;
    reg [15:0] clock_ratio = 1;

    always @(posedge wclk) wclk_counter <= wclk_counter + 1;
    always @(posedge rclk) rclk_counter <= rclk_counter + 1;

    always @(posedge wclk) begin
        if (wclk_counter == 16'hFFFF) begin
            clock_ratio <= (rclk_counter + 1) / (wclk_counter + 1);
            wclk_counter <= 0;
            rclk_counter <= 0;
            
            // Adjust thresholds based on clock ratio
            if (clock_ratio > 2) begin
                full_threshold <= DEPTH - 2;
                empty_threshold <= 1;
            end else if (clock_ratio < 1) begin
                full_threshold <= DEPTH - 3;
                empty_threshold <= 2;
            end else begin
                full_threshold <= DEPTH - 1;
                empty_threshold <= 0;
            end
        end
    end

    // Full/empty detection with adaptive thresholds
    always @(posedge wclk) begin
        wfull <= (wptr_bin - rptr_sync[sync_stages]) >= full_threshold;
    end

    always @(posedge rclk) begin
        rempty <= (wptr_sync[sync_stages] - rptr_bin) <= empty_threshold;
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

    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter EARLY_WARNING = 2  // Early warning threshold
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
    output reg w_almost_full,  // Early warning
    output reg r_almost_empty, // Early warning
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Clock ratio detection
    reg [15:0] wclk_cnt, rclk_cnt;
    reg [15:0] w2r_ratio, r2w_ratio;
    reg [1:0] sync_stages_w2r, sync_stages_r2w;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wclk_cnt <= 0;
            w2r_ratio <= 0;
        end else begin
            wclk_cnt <= wclk_cnt + 1;
            if (wclk_cnt == 0) begin
                w2r_ratio <= rclk_cnt;
                rclk_cnt <= 0;
            end
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rclk_cnt <= 0;
            r2w_ratio <= 0;
        end else begin
            rclk_cnt <= rclk_cnt + 1;
            if (rclk_cnt == 0) begin
                r2w_ratio <= wclk_cnt;
                wclk_cnt <= 0;
            end
        end
    end

    // Dynamic synchronization stage calculation
    always @(*) begin
        case (w2r_ratio)
            0: sync_stages_w2r = 2;
            1: sync_stages_w2r = 2;
            2: sync_stages_w2r = 3;
            default: sync_stages_w2r = (w2r_ratio < 8) ? 3 : 4;
        endcase

        case (r2w_ratio)
            0: sync_stages_r2w = 2;
            1: sync_stages_r2w = 2;
            2: sync_stages_r2w = 3;
            default: sync_stages_r2w = (r2w_ratio < 8) ? 3 : 4;
        endcase
    end

    // Pointer management
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);

    // Hierarchical synchronization
    reg [PTR_WIDTH-1:0] rptr_sync [0:3];
    reg [PTR_WIDTH-1:0] wptr_sync [0:3];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (int i=0; i<=3; i++) rptr_sync[i] <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            for (int i=1; i<sync_stages_w2r; i++)
                rptr_sync[i] <= rptr_sync[i-1];
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (int i=0; i<=3; i++) wptr_sync[i] <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            for (int i=1; i<sync_stages_r2w; i++)
                wptr_sync[i] <= wptr_sync[i-1];
        end
    end

    // Predictive status calculation
    wire [PTR_WIDTH-1:0] wptr_synced = wptr_sync[sync_stages_r2w-1];
    wire [PTR_WIDTH-1:0] rptr_synced = rptr_sync[sync_stages_w2r-1];
    
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + winc && !wfull;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + rinc && !rempty;
    
    wire [PTR_WIDTH-1:0] wptr_next_gray = wptr_next ^ (wptr_next >> 1);
    wire [PTR_WIDTH-1:0] rptr_next_gray = rptr_next ^ (rptr_next >> 1);

    // Memory interface
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // Pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_next;
        end
    end

    // Status flags with predictive calculation
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
            w_almost_full <= 0;
        end else begin
            wfull <= (wptr_next_gray == {~rptr_synced[PTR_WIDTH-1:PTR_WIDTH-2], 
                                       rptr_synced[PTR_WIDTH-3:0]});
            w_almost_full <= (wptr_next + EARLY_WARNING >= 
                             {~rptr_synced[PTR_WIDTH-1], rptr_synced[PTR_WIDTH-2:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
            r_almost_empty <= 1;
        end else begin
            rempty <= (rptr_gray == wptr_synced);
            r_almost_empty <= (rptr_bin + EARLY_WARNING >= wptr_synced);
        end
    end

endmodule

// Enhanced dual-port RAM with clock gating
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

    (* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write with clock gating
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read with output register
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (renc) begin
            rdata_reg <= mem[raddr];
        end
    end
    
    assign rdata = rdata_reg;

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 2  // Configurable sync stages
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

    // Validate parameters
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
        if (SYNC_STAGES < 2) begin
            $error("SYNC_STAGES must be at least 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH:0] wptr_gray_parity; // Gray + parity
    reg [PTR_WIDTH-1:0] rptr_sync [0:SYNC_STAGES-1];
    reg [PTR_WIDTH-1:0] rptr_maj; // Majority voted sync
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH:0] rptr_gray_parity;
    reg [PTR_WIDTH-1:0] wptr_sync [0:SYNC_STAGES-1];
    reg [PTR_WIDTH-1:0] wptr_maj;
    
    // Predictive pointers
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + winc && !wfull;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + rinc && !rempty;
    
    // Memory control
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    
    // Parity generation
    function parity_gen(input [PTR_WIDTH-1:0] data);
        parity_gen = ^data;
    endfunction
    
    // Enhanced Gray code with parity
    function [PTR_WIDTH:0] bin2gray_par(input [PTR_WIDTH-1:0] bin);
        bin2gray_par = {bin ^ (bin >> 1), parity_gen(bin)};
    endfunction
    
    // Pointer synchronization with majority voting
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (int i=0; i<SYNC_STAGES; i++) rptr_sync[i] <= 0;
            rptr_maj <= 0;
        end else begin
            // Shift register synchronization
            rptr_sync[0] <= rptr_gray;
            for (int i=1; i<SYNC_STAGES; i++)
                rptr_sync[i] <= rptr_sync[i-1];
            
            // Majority voting
            rptr_maj <= (rptr_sync[SYNC_STAGES-1] & rptr_sync[SYNC_STAGES-2]) | 
                       (rptr_sync[SYNC_STAGES-1] & rptr_sync[SYNC_STAGES-3]) |
                       (rptr_sync[SYNC_STAGES-2] & rptr_sync[SYNC_STAGES-3]);
        end
    end
    
    // Similar synchronization for read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (int i=0; i<SYNC_STAGES; i++) wptr_sync[i] <= 0;
            wptr_maj <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            for (int i=1; i<SYNC_STAGES; i++)
                wptr_sync[i] <= wptr_sync[i-1];
                
            wptr_maj <= (wptr_sync[SYNC_STAGES-1] & wptr_sync[SYNC_STAGES-2]) | 
                       (wptr_sync[SYNC_STAGES-1] & wptr_sync[SYNC_STAGES-3]) |
                       (wptr_sync[SYNC_STAGES-2] & wptr_sync[SYNC_STAGES-3]);
        end
    end
    
    // Write pointer update with parity
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray_parity <= bin2gray_par(0);
        end else if (wenc) begin
            wptr_bin <= wptr_next;
            wptr_gray_parity <= bin2gray_par(wptr_next);
        end
        wptr_gray <= wptr_gray_parity[PTR_WIDTH-1:0];
    end
    
    // Read pointer update with parity
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray_parity <= bin2gray_par(0);
        end else if (renc) begin
            rptr_bin <= rptr_next;
            rptr_gray_parity <= bin2gray_par(rptr_next);
        end
        rptr_gray <= rptr_gray_parity[PTR_WIDTH-1:0];
    end
    
    // Early status detection using next pointers
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            // Check both current and next state
            wfull <= ((wptr_gray == {~rptr_maj[PTR_WIDTH-1:PTR_WIDTH-2], 
                      rptr_maj[PTR_WIDTH-3:0]}) ||
                     ((bin2gray_par(wptr_next)[PTR_WIDTH-1:0] == 
                      {~rptr_maj[PTR_WIDTH-1:PTR_WIDTH-2], 
                      rptr_maj[PTR_WIDTH-3:0]}));
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            rempty <= (rptr_gray == wptr_maj) || 
                     (bin2gray_par(rptr_next)[PTR_WIDTH-1:0] == wptr_maj);
        end
    end
    
    // Power-gated memory implementation
    dual_port_ram_pg #(
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
        .rdata(rdata),
        .wbank_en(|wptr_bin[ADDR_WIDTH-1:ADDR_WIDTH-2]),
        .rbank_en(|rptr_bin[ADDR_WIDTH-1:ADDR_WIDTH-2])
    );

endmodule

// Power-gated dual-port RAM
module dual_port_ram_pg #(
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
    output reg [WIDTH-1:0] rdata,
    input wbank_en,
    input rbank_en
);

    (* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
    (* gated_clock *) reg wclk_gated, rclk_gated;
    
    // Clock gating based on bank enable
    always @(*) begin
        wclk_gated = wclk & wbank_en;
        rclk_gated = rclk & rbank_en;
    end
    
    // Write with gated clock
    always @(posedge wclk_gated) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end
    
    // Read with gated clock
    always @(posedge rclk_gated) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
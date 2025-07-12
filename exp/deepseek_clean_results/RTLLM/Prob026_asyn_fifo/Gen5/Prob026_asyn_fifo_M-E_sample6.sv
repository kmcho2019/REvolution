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

    // Parameter validation
    if (DEPTH < 2 || (DEPTH & (DEPTH-1)) != 0) begin
        $error("FIFO depth must be power of 2 and >= 2");
    end

    localparam PTR_WIDTH = $clog2(DEPTH) + 1;
    
    // Dual-clock Gray counter for write pointer
    reg [PTR_WIDTH-1:0] wptr_gray, wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + (winc & !wfull);
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_next;
            wptr_gray <= wptr_next ^ (wptr_next >> 1);
        end
    end

    // Dual-clock Gray counter for read pointer
    reg [PTR_WIDTH-1:0] rptr_gray, rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + (rinc & !rempty);
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_next;
            rptr_gray <= rptr_next ^ (rptr_next >> 1);
        end
    end

    // Adaptive synchronizers
    wire [PTR_WIDTH-1:0] wptr_sync, rptr_sync;
    
    adaptive_sync #(.WIDTH(PTR_WIDTH), .STAGES(SYNC_STAGES)) wsync (
        .clk(rclk),
        .rstn(rrstn),
        .d(wptr_gray),
        .q(wptr_sync)
    );
    
    adaptive_sync #(.WIDTH(PTR_WIDTH), .STAGES(SYNC_STAGES)) rsync (
        .clk(wclk),
        .rstn(wrstn),
        .d(rptr_gray),
        .q(rptr_sync)
    );

    // Predictive flag generation
    wire [PTR_WIDTH-1:0] wptr_next_gray = wptr_next ^ (wptr_next >> 1);
    wire [PTR_WIDTH-1:0] rptr_next_gray = rptr_next ^ (rptr_next >> 1);
    
    always @(*) begin
        // Full when next write would catch read pointer
        wfull = (wptr_next_gray == {~rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                  rptr_sync[PTR_WIDTH-3:0]});
        
        // Empty when next read would catch write pointer
        rempty = (rptr_next_gray == wptr_sync);
    end

    // Smart RAM interface
    wire ram_wen = winc & !wfull;
    wire ram_ren = rinc & !rempty;
    
    dp_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) memory (
        .wclk(wclk),
        .wen(ram_wen),
        .waddr(wptr_bin[PTR_WIDTH-2:0]),
        .wdata(wdata),
        .rclk(rclk),
        .ren(ram_ren),
        .raddr(rptr_bin[PTR_WIDTH-2:0]),
        .rdata(rdata)
    );
endmodule

module adaptive_sync #(
    parameter WIDTH = 4,
    parameter STAGES = 2
)(
    input clk,
    input rstn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    reg [WIDTH-1:0] sync_reg [0:STAGES-1];
    integer i;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i = 0; i < STAGES; i = i + 1)
                sync_reg[i] <= 0;
            q <= 0;
        end else begin
            sync_reg[0] <= d;
            for (i = 1; i < STAGES; i = i + 1)
                sync_reg[i] <= sync_reg[i-1];
            q <= sync_reg[STAGES-1];
        end
    end
endmodule

module dp_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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
    
    // Write with byte enable
    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end
    
    // Read with output register
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (ren) rdata_reg <= mem[raddr];
    end
    
    assign rdata = rdata_reg;
endmodule
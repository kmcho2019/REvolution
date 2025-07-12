module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 2  // Default to 2-stage synchronizer
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wire wfull,
    output wire rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_gray_next;
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_gray_next;
    
    // Synchronized pointers
    wire [PTR_WIDTH-1:0] rptr_gray_sync;
    wire [PTR_WIDTH-1:0] wptr_gray_sync;
    
    // Control signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    
    // Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = (bin >> 1) ^ bin;
    endfunction
    
    // Write pointer management
    assign wptr_bin_next = wptr_bin + wen;
    assign wptr_gray_next = bin2gray(wptr_bin_next);
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
        end
    end
    
    // Write pointer gray register
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_gray <= 0;
        end else begin
            wptr_gray <= wptr_gray_next;
        end
    end
    
    // Read pointer management
    assign rptr_bin_next = rptr_bin + ren;
    assign rptr_gray_next = bin2gray(rptr_bin_next);
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
        end
    end
    
    // Read pointer gray register
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_gray <= 0;
        end else begin
            rptr_gray <= rptr_gray_next;
        end
    end
    
    // Memory write
    always @(posedge wclk) begin
        if (wen) begin
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Memory read
    always @(posedge rclk) begin
        if (ren) begin
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end
    
    // Synchronizer chains
    sync_chain #(
        .WIDTH(PTR_WIDTH),
        .STAGES(SYNC_STAGES)
    sync_rptr (
        .clk(wclk),
        .rstn(wrstn),
        .din(rptr_gray),
        .dout(rptr_gray_sync)
    );
    
    sync_chain #(
        .WIDTH(PTR_WIDTH),
        .STAGES(SYNC_STAGES))
    sync_wptr (
        .clk(rclk),
        .rstn(rrstn),
        .din(wptr_gray),
        .dout(wptr_gray_sync)
    );
    
    // Flag generation
    assign wfull = (wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1], 
                    rptr_gray_sync[PTR_WIDTH-2:0]});
    
    assign rempty = (rptr_gray == wptr_gray_sync);

endmodule

// Synchronizer chain module
module sync_chain #(
    parameter WIDTH = 4,
    parameter STAGES = 2
) (
    input clk,
    input rstn,
    input [WIDTH-1:0] din,
    output [WIDTH-1:0] dout
);
    
    reg [WIDTH-1:0] sync_reg [0:STAGES-1];
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (int i = 0; i < STAGES; i = i + 1) begin
                sync_reg[i] <= 0;
            end
        end else begin
            sync_reg[0] <= din;
            for (int i = 1; i < STAGES; i = i + 1) begin
                sync_reg[i] <= sync_reg[i-1];
            end
        end
    end
    
    assign dout = sync_reg[STAGES-1];
endmodule
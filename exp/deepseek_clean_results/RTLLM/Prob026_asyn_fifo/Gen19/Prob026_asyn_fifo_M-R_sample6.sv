module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 2
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
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc && !wfull);
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_bin_next ^ (wptr_bin_next >> 1);
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc && !rempty);
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_bin_next ^ (rptr_bin_next >> 1);
    
    // Synchronized pointers
    wire [PTR_WIDTH-1:0] rptr_gray_sync;
    wire [PTR_WIDTH-1:0] wptr_gray_sync;
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end
    
    // Memory write operation
    always @(posedge wclk) begin
        if (winc && !wfull) begin
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Memory read operation
    always @(posedge rclk) begin
        if (rinc && !rempty) begin
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end
    
    // Pointer synchronizers
    sync_chain #(.WIDTH(PTR_WIDTH)) sync_rptr (
        .clk(wclk),
        .rstn(wrstn),
        .din(rptr_gray),
        .dout(rptr_gray_sync)
    );
    
    sync_chain #(.WIDTH(PTR_WIDTH)) sync_wptr (
        .clk(rclk),
        .rstn(rrstn),
        .din(wptr_gray),
        .dout(wptr_gray_sync)
    );
    
    // Flag generation
    assign wfull = (wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                rptr_gray_sync[PTR_WIDTH-3:0]});
    
    assign rempty = (rptr_gray == wptr_gray_sync);

endmodule

// Synchronizer module with parameterized width
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
    integer i;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i = 0; i < STAGES; i = i + 1)
                sync_reg[i] <= 0;
        end else begin
            sync_reg[0] <= din;
            for (i = 1; i < STAGES; i = i + 1)
                sync_reg[i] <= sync_reg[i-1];
        end
    end
    
    assign dout = sync_reg[STAGES-1];
endmodule
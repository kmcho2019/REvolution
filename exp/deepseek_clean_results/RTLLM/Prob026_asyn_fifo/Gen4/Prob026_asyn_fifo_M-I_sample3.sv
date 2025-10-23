module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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
    if (DEPTH < 2 || (DEPTH & (DEPTH-1)) != 0) begin
        $error("FIFO depth must be power of 2 and at least 2");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Dual-port RAM instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc & !wfull),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & !rempty),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
    
    // Write domain signals
    reg [ADDR_WIDTH:0] wptr_bin;
    reg [ADDR_WIDTH:0] wptr_gray;
    wire [ADDR_WIDTH:0] wptr_next = wptr_bin + (winc & !wfull);
    
    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin;
    reg [ADDR_WIDTH:0] rptr_gray;
    wire [ADDR_WIDTH:0] rptr_next = rptr_bin + (rinc & !rempty);
    
    // Synchronizers
    wire [ADDR_WIDTH:0] wptr_sync;
    wire [ADDR_WIDTH:0] rptr_sync;
    
    sync_cell #(.WIDTH(ADDR_WIDTH+1)) wptr_sync_inst (
        .clk(rclk),
        .rstn(rrstn),
        .d(wptr_gray),
        .q(wptr_sync)
    );
    
    sync_cell #(.WIDTH(ADDR_WIDTH+1)) rptr_sync_inst (
        .clk(wclk),
        .rstn(wrstn),
        .d(rptr_gray),
        .q(rptr_sync)
    );
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_next;
            wptr_gray <= wptr_next ^ (wptr_next >> 1);
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_next;
            rptr_gray <= rptr_next ^ (rptr_next >> 1);
        end
    end
    
    // Full and empty detection
    assign wfull = (wptr_gray == {~rptr_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                                 rptr_sync[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync);

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
    
    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end
    
    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end
endmodule

module sync_cell #(
    parameter WIDTH = 4
)(
    input clk,
    input rstn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    reg [WIDTH-1:0] sync_reg;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_reg <= 0;
            q <= 0;
        end else begin
            sync_reg <= d;
            q <= sync_reg;
        end
    end
endmodule
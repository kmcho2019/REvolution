module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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
    output wire [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr(wptr[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr(rptr[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr;
    wire [PTR_WIDTH-1:0] wptr_next = wptr + (winc && !wfull);
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr;
    wire [PTR_WIDTH-1:0] rptr_next = rptr + (rinc && !rempty);
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    
    // Synchronizers
    wire [PTR_WIDTH-1:0] rptr_sync;
    wire [PTR_WIDTH-1:0] wptr_sync;
    
    sync_cell #(.WIDTH(PTR_WIDTH)) sync_r2w (
        .clk(wclk),
        .rstn(wrstn),
        .din(rptr_gray),
        .dout(rptr_sync)
    );
    
    sync_cell #(.WIDTH(PTR_WIDTH)) sync_w2r (
        .clk(rclk),
        .rstn(rrstn),
        .din(wptr_gray),
        .dout(wptr_sync)
    );
    
    // Pointer updates
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wptr <= 0;
        else wptr <= wptr_next;
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rptr <= 0;
        else rptr <= rptr_next;
    end
    
    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                rptr_sync[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync);

endmodule

// Dual-port RAM module
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

// Two-stage synchronizer
module sync_cell #(
    parameter WIDTH = 4
) (
    input clk,
    input rstn,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout
);
    
    reg [WIDTH-1:0] sync_reg;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_reg <= 0;
            dout <= 0;
        end else begin
            sync_reg <= din;
            dout <= sync_reg;
        end
    end

endmodule
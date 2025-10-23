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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface signals
    wire wen;
    wire ren;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Pointer signals
    wire [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray;
    
    // Synchronized pointers
    wire [PTR_WIDTH-1:0] wptr_gray_sync;
    wire [PTR_WIDTH-1:0] rptr_gray_sync;

    // Control signals
    assign wen = winc && !wfull;
    assign ren = rinc && !rempty;

    // Instantiate memory - fixed parameter passing
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_mem (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write Controller
    write_ctrl #(
        .PTR_WIDTH(PTR_WIDTH),
        .SYNC_STAGES(SYNC_STAGES)
    ) u_write_ctrl (
        .clk(wclk),
        .rstn(wrstn),
        .inc(wen),
        .rptr_gray_sync(rptr_gray_sync),
        .wptr_bin(wptr_bin),
        .wptr_gray(wptr_gray),
        .waddr(waddr),
        .wfull(wfull)
    );

    // Read Controller
    read_ctrl #(
        .PTR_WIDTH(PTR_WIDTH),
        .SYNC_STAGES(SYNC_STAGES)
    ) u_read_ctrl (
        .clk(rclk),
        .rstn(rrstn),
        .inc(ren),
        .wptr_gray_sync(wptr_gray_sync),
        .rptr_bin(rptr_bin),
        .rptr_gray(rptr_gray),
        .raddr(raddr),
        .rempty(rempty)
    );

    // Cross-domain synchronizers
    sync_chain #(
        .WIDTH(PTR_WIDTH),
        .STAGES(SYNC_STAGES)
    ) u_sync_w2r (
        .clk(rclk),
        .rstn(rrstn),
        .d(wptr_gray),
        .q(wptr_gray_sync)
    );

    sync_chain #(
        .WIDTH(PTR_WIDTH),
        .STAGES(SYNC_STAGES)
    ) u_sync_r2w (
        .clk(wclk),
        .rstn(wrstn),
        .d(rptr_gray),
        .q(rptr_gray_sync)
    );

endmodule

// Dual-port memory
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

// Write controller
module write_ctrl #(
    parameter PTR_WIDTH = 5,
    parameter SYNC_STAGES = 2
) (
    input clk,
    input rstn,
    input inc,
    input [PTR_WIDTH-1:0] rptr_gray_sync,
    output reg [PTR_WIDTH-1:0] wptr_bin,
    output reg [PTR_WIDTH-1:0] wptr_gray,
    output [PTR_WIDTH-2:0] waddr,
    output reg wfull
);
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + inc;
    wire [PTR_WIDTH-1:0] wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;
    
    assign waddr = wptr_bin[PTR_WIDTH-2:0];
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wfull <= 0;
        end else begin
            if (inc && !wfull) begin
                wptr_bin <= wptr_bin_next;
                wptr_gray <= wptr_gray_next;
            end
            
            wfull <= (wptr_gray_next == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                     rptr_gray_sync[PTR_WIDTH-3:0]});
        end
    end
endmodule

// Read controller
module read_ctrl #(
    parameter PTR_WIDTH = 5,
    parameter SYNC_STAGES = 2
) (
    input clk,
    input rstn,
    input inc,
    input [PTR_WIDTH-1:0] wptr_gray_sync,
    output reg [PTR_WIDTH-1:0] rptr_bin,
    output reg [PTR_WIDTH-1:0] rptr_gray,
    output [PTR_WIDTH-2:0] raddr,
    output reg rempty
);
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + inc;
    wire [PTR_WIDTH-1:0] rptr_gray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;
    
    assign raddr = rptr_bin[PTR_WIDTH-2:0];
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rempty <= 1;
        end else begin
            if (inc && !rempty) begin
                rptr_bin <= rptr_bin_next;
                rptr_gray <= rptr_gray_next;
            end
            
            rempty <= (rptr_gray_next == wptr_gray_sync);
        end
    end
endmodule

// Synchronizer chain
module sync_chain #(
    parameter WIDTH = 5,
    parameter STAGES = 2
) (
    input clk,
    input rstn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    reg [WIDTH-1:0] sync_reg [0:STAGES-1];
    integer i;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i = 0; i < STAGES; i = i+1)
                sync_reg[i] <= 0;
            q <= 0;
        end else begin
            sync_reg[0] <= d;
            for (i = 1; i < STAGES; i = i+1)
                sync_reg[i] <= sync_reg[i-1];
            q <= sync_reg[STAGES-1];
        end
    end
endmodule
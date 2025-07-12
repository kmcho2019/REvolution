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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Instantiate RAM module
    dp_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wen(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .ren(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write pointer logic
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + wen;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [PTR_WIDTH-1:0] wptr_next_gray = wptr_next ^ (wptr_next >> 1);
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    // Read pointer logic
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + ren;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Pointer registers
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wptr_bin <= 0;
        else wptr_bin <= wptr_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rptr_bin <= 0;
        else rptr_bin <= rptr_next;
    end

    // Synchronizers
    wire [PTR_WIDTH-1:0] rptr_sync;
    sync_cell #(.WIDTH(PTR_WIDTH)) u_rptr_sync (
        .clk(wclk),
        .rstn(wrstn),
        .d(rptr_gray),
        .q(rptr_sync)
    );

    wire [PTR_WIDTH-1:0] wptr_sync;
    sync_cell #(.WIDTH(PTR_WIDTH)) u_wptr_sync (
        .clk(rclk),
        .rstn(rrstn),
        .d(wptr_gray),
        .q(wptr_sync)
    );

    // Full/empty detection
    assign wfull = (wptr_next_gray == {~rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2],
                                     rptr_sync[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync);

endmodule

module dp_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    always @(posedge rclk) if (ren) rdata <= mem[raddr];

endmodule

module sync_cell #(
    parameter WIDTH = 4
) (
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
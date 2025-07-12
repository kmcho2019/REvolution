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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc & !wfull);
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_bin_next ^ (wptr_bin_next >> 1);

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc & !rempty);
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_bin_next ^ (rptr_bin_next >> 1);

    // Synchronizers
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
        end
    end

    // Cross-clock synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Flag generation
    assign wfull = (wptr_gray_next == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                     rptr_gray_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray_next == wptr_gray_sync2);

    // RAM interface
    wire ram_wen = winc & !wfull;
    wire ram_ren = rinc & !rempty;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram (
        .wclk(wclk),
        .wenc(ram_wen),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ram_ren),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
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

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];
endmodule
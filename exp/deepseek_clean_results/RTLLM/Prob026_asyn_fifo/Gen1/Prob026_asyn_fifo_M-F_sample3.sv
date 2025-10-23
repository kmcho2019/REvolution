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

    // Dual-port RAM signals
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Write pointer and Gray code generation
    reg [ADDR_WIDTH:0] waddr_bin = 0;
    reg [ADDR_WIDTH:0] wptr = 0;
    wire [ADDR_WIDTH:0] wgray_next = (waddr_bin + 1) ^ ((waddr_bin + 1) >> 1);
    assign waddr = waddr_bin[ADDR_WIDTH-1:0];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else if (wenc) begin
            waddr_bin <= waddr_bin + 1;
            wptr <= wgray_next;
        end
    end

    // Read pointer and Gray code generation
    reg [ADDR_WIDTH:0] raddr_bin = 0;
    reg [ADDR_WIDTH:0] rptr = 0;
    wire [ADDR_WIDTH:0] rgray_next = (raddr_bin + 1) ^ ((raddr_bin + 1) >> 1);
    assign raddr = raddr_bin[ADDR_WIDTH-1:0];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else if (renc) begin
            raddr_bin <= raddr_bin + 1;
            rptr <= rgray_next;
        end
    end

    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_sync1 = 0, rptr_sync2 = 0;
    reg [ADDR_WIDTH:0] wptr_sync1 = 0, wptr_sync2 = 0;

    // Write clock domain synchronizer (sync read pointer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Read clock domain synchronizer (sync write pointer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Full and empty generation
    assign rempty = (rptr == wptr_sync2);
    assign wfull = (wgray_next == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                  rptr_sync2[ADDR_WIDTH-2:0]});

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule

// Dual-port RAM module (single declaration)
module dual_port_RAM #(
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

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
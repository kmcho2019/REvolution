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

    // Dual-port RAM instantiation
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

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

    // Write pointer logic
    reg [ADDR_WIDTH:0] waddr_bin = 0;
    reg [ADDR_WIDTH:0] wptr = 0;
    reg [ADDR_WIDTH:0] wptr_buff = 0;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else begin
            if (wenc) begin
                waddr_bin <= waddr_bin + 1;
            end
            wptr <= waddr_bin ^ (waddr_bin >> 1); // Binary to Gray
            wptr_buff <= wptr;
        end
    end

    assign waddr = waddr_bin[ADDR_WIDTH-1:0];

    // Read pointer logic
    reg [ADDR_WIDTH:0] raddr_bin = 0;
    reg [ADDR_WIDTH:0] rptr = 0;
    reg [ADDR_WIDTH:0] rptr_buff = 0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
        end else begin
            if (renc) begin
                raddr_bin <= raddr_bin + 1;
            end
            rptr <= raddr_bin ^ (raddr_bin >> 1); // Binary to Gray
            rptr_buff <= rptr;
        end
    end

    assign raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Synchronizers
    reg [ADDR_WIDTH:0] wptr_syn0 = 0;
    reg [ADDR_WIDTH:0] wptr_syn1 = 0;
    reg [ADDR_WIDTH:0] rptr_syn0 = 0;
    reg [ADDR_WIDTH:0] rptr_syn1 = 0;

    // Write pointer synchronized to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn0 <= 0;
            wptr_syn1 <= 0;
        end else begin
            wptr_syn0 <= wptr;
            wptr_syn1 <= wptr_syn0;
        end
    end

    // Read pointer synchronized to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn0 <= 0;
            rptr_syn1 <= 0;
        end else begin
            rptr_syn0 <= rptr;
            rptr_syn1 <= rptr_syn0;
        end
    end

    // Full and empty generation
    assign rempty = (rptr == wptr_syn1);
    assign wfull = ((wptr[ADDR_WIDTH] != rptr_syn1[ADDR_WIDTH]) &&
                  (wptr[ADDR_WIDTH-1:0] == rptr_syn1[ADDR_WIDTH-1:0]);

endmodule

// Dual-port RAM module
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
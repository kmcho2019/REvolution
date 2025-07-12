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
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    // Validate parameters
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM Interface
    wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Dual-port RAM with registered outputs
    dp_mem #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_mem (
        .wclk(wclk),
        .wen(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .ren(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write Domain
    reg [PTR_WIDTH-1:0] wptr, wptr_next;
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [ADDR_WIDTH-1:0] rptr_sync;

    // Partial Gray code conversion (only MSBs need full Gray)
    wire [PTR_WIDTH-1:0] wptr_gray_next = (wptr_next ^ (wptr_next >> 1));

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr <= wptr_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    always @(*) begin
        wptr_next = wptr + 1;
    end

    // Read pointer sync (only need ADDR_WIDTH bits)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync <= 0;
        end else begin
            rptr_sync <= rptr[ADDR_WIDTH-1:0];
        end
    end

    // Early full detection
    wire ptr_diff = (wptr[ADDR_WIDTH-1:0] - rptr_sync);
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            wfull <= (ptr_diff == DEPTH-1) | (wptr[PTR_WIDTH-1] != rptr_sync[ADDR_WIDTH-1]);
        end
    end

    // Read Domain (mirror structure)
    reg [PTR_WIDTH-1:0] rptr, rptr_next;
    reg [PTR_WIDTH-1:0] rptr_gray;
    reg [ADDR_WIDTH-1:0] wptr_sync;

    wire [PTR_WIDTH-1:0] rptr_gray_next = (rptr_next ^ (rptr_next >> 1));

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr <= rptr_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    always @(*) begin
        rptr_next = rptr + 1;
    end

    // Write pointer sync
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync <= 0;
        end else begin
            wptr_sync <= wptr[ADDR_WIDTH-1:0];
        end
    end

    // Early empty detection
    wire ptr_match = (rptr[ADDR_WIDTH-1:0] == wptr_sync);
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            rempty <= ptr_match & (rptr[PTR_WIDTH-1] == wptr_sync[ADDR_WIDTH-1]);
        end
    end

    // Cross-domain handshake signals
    reg ack_w2r, ack_r2w;
    reg req_w2r, req_r2w;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            req_w2r <= 0;
        end else if (wen) begin
            req_w2r <= ~req_w2r;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            ack_w2r <= 0;
        end else begin
            ack_w2r <= req_w2r;
        end
    end

endmodule

// Enhanced dual-port memory with output register
module dp_mem #(
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
    reg [WIDTH-1:0] rdata_reg;

    always @(posedge wclk) begin
        if (wen) begin
            mem[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (ren) begin
            rdata_reg <= mem[raddr];
        end
        rdata <= rdata_reg;  // Additional pipeline stage
    end

endmodule
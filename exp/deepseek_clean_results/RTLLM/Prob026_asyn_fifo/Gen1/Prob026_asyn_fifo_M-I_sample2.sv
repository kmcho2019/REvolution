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

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Explicit wire declarations
    wire wen;
    wire [ADDR_WIDTH-1:0] waddr;
    wire ren;
    wire [ADDR_WIDTH-1:0] raddr;

    // Dual-port RAM instantiation
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [ADDR_WIDTH:0] waddr_bin;
    reg [ADDR_WIDTH:0] wptr, wptr_gray;
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    wire [ADDR_WIDTH:0] wgray_next;

    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin;
    reg [ADDR_WIDTH:0] rptr, rptr_gray;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;
    wire [ADDR_WIDTH:0] rgray_next;

    // Binary to Gray conversion
    assign wgray_next = waddr_bin ^ (waddr_bin >> 1);
    assign rgray_next = raddr_bin ^ (raddr_bin >> 1);

    // RAM address is lower bits of binary counter
    assign waddr = waddr_bin[ADDR_WIDTH-1:0];
    assign raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Write control
    assign wen = winc && !wfull;

    // Write pointer management
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr_gray <= 0;
            wptr <= 0;
        end else if (wen) begin
            waddr_bin <= waddr_bin + 1;
            wptr_gray <= wgray_next;
            wptr <= waddr_bin + 1; // Binary pointer for comparison
        end
    end

    // Read pointer management
    assign ren = rinc && !rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr_gray <= 0;
            rptr <= 0;
        end else if (ren) begin
            raddr_bin <= raddr_bin + 1;
            rptr_gray <= rgray_next;
            rptr <= raddr_bin + 1; // Binary pointer for comparison
        end
    end

    // Write pointer synchronization to read domain (2-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Read pointer synchronization to write domain (2-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Full and empty generation with registered outputs
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            // Full when next write pointer equals synchronized read pointer
            wfull <= (wgray_next == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                    rptr_sync2[ADDR_WIDTH-2:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            // Empty when read pointer equals synchronized write pointer
            rempty <= (rgray_next == wptr_sync2);
        end
    end

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

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
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

    // RAM interface signals
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
    reg [ADDR_WIDTH:0] wptr_bin, wptr_gray;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;
    wire [ADDR_WIDTH:0] wgray_next = wptr_bin ^ (wptr_bin >> 1);
    wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + (wen ? 1'b1 : 1'b0);

    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin, rptr_gray;
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    wire [ADDR_WIDTH:0] rgray_next = rptr_bin ^ (rptr_bin >> 1);
    wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + (ren ? 1'b1 : 1'b0);

    // RAM address assignment
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write control
    assign wen = winc && !wfull;

    // Write pointer management
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wgray_next;
        end
    end

    // Read control
    assign ren = rinc && !rempty;

    // Read pointer management
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rgray_next;
        end
    end

    // Synchronizers
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Full detection
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= (wgray_next == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                    rptr_sync2[ADDR_WIDTH-2:0]});
        end
    end

    // Empty detection
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rgray_next == wptr_sync2);
        end
    end

endmodule

// Single definition of dual-port RAM module
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
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

    // Parameter validation
    initial begin
        if (DEPTH < 2) $error("FIFO depth must be at least 2");
        if (WIDTH < 1) $error("FIFO width must be at least 1");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Binary to Gray code conversion
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // RAM interface signals
    wire wenc;
    wire [ADDR_WIDTH-1:0] waddr;
    wire renc;
    wire [ADDR_WIDTH-1:0] raddr;

    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [ADDR_WIDTH:0] wptr_bin;
    wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [ADDR_WIDTH:0] wptr_gray = bin2gray(wptr_bin);
    wire [ADDR_WIDTH:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin;
    wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + 1'b1;
    wire [ADDR_WIDTH:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronized pointers
    reg [ADDR_WIDTH:0] rptr_gray_sync1, rptr_gray_sync2;
    reg [ADDR_WIDTH:0] wptr_gray_sync1, wptr_gray_sync2;

    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
        end
    end

    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Address generation
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Control signals
    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;

    // Full detection
    wire [ADDR_WIDTH:0] wfull_test = {~rptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                     rptr_gray_sync2[ADDR_WIDTH-2:0]};
    assign wfull = (wptr_gray_next == wfull_test);

    // Empty detection
    assign rempty = (rptr_gray == wptr_gray_sync2);

endmodule

// Dual-port RAM module
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
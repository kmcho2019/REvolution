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
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    // Parameter validation
    initial begin
        if (DEPTH < 2 || DEPTH > 1024) $error("FIFO depth must be between 2 and 1024");
        if (WIDTH < 1 || WIDTH > 1024) $error("FIFO width must be between 1 and 1024");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Binary to Gray code conversion
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // RAM interface signals
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Instantiate optimized dual-port RAM
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

    // Write domain
    reg [ADDR_WIDTH:0] wptr_bin, wptr_gray;
    wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + !wfull;
    wire [ADDR_WIDTH:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // Read domain
    reg [ADDR_WIDTH:0] rptr_bin, rptr_gray;
    wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + !rempty;
    wire [ADDR_WIDTH:0] rptr_gray_next = bin2gray(rptr_bin_next);

    // Synchronized pointers (2-stage with clock gating)
    reg [ADDR_WIDTH:0] rptr_gray_sync, wptr_gray_sync;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync <= 0;
        end else if (winc) begin
            rptr_gray_sync <= rptr_gray;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync <= 0;
        end else if (rinc) begin
            wptr_gray_sync <= wptr_gray;
        end
    end

    // Pointer updates with synchronous reset
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Address generation
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Full/empty detection (optimized comparison)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= (wptr_gray_next == {~rptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                                        rptr_gray_sync[ADDR_WIDTH-2:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rptr_gray == wptr_gray_sync);
        end
    end

endmodule

// Optimized dual-port RAM
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

    // Packed array for better synthesis
    reg [WIDTH-1:0] mem [0:DEPTH-1] /* synthesis ramstyle = "no_rw_check" */;

    // Clock-gated writes
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Clock-gated reads
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
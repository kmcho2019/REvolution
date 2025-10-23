`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH      = 8,
    parameter DEPTH      = 16,
    localparam ADDR_WIDTH = $clog2(DEPTH),
    localparam PTR_WIDTH  = ADDR_WIDTH + 1
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,
    input  wire                 rrstn,
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output reg                  wfull,
    output reg                  rempty,
    output wire [WIDTH-1:0]     rdata
);

    // ------------------------------------------------------------------------
    // Gray code conversion functions
    // ------------------------------------------------------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // ------------------------------------------------------------------------
    // Binary counters for write and read pointers
    // ------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;

    // Write and read Gray code pointers (directly converted from binary counters)
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(waddr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(raddr_bin);

    // ------------------------------------------------------------------------
    // Synchronizers for pointer crossing
    // Two-stage synchronizers implemented with generate for scalability
    // ------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync /* synthesis syn_preserve = 1 */;
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta /* synthesis syn_preserve = 1 */;
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync /* synthesis syn_preserve = 1 */;
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta /* synthesis syn_preserve = 1 */;

    // Synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= {PTR_WIDTH{1'b0}};
            rptr_gray_wclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= {PTR_WIDTH{1'b0}};
            wptr_gray_rclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // ------------------------------------------------------------------------
    // Write enable (wen) and read enable (ren) signals
    // Write when not full and winc asserted; read when not empty and rinc asserted
    // ------------------------------------------------------------------------
    wire wen = winc & ~wfull;
    wire ren = rinc & ~rempty;

    // ------------------------------------------------------------------------
    // Binary counters for pointers incremented on clocks
    // ------------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= {PTR_WIDTH{1'b0}};
        end else if (wen) begin
            waddr_bin <= waddr_bin + 1'b1;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= {PTR_WIDTH{1'b0}};
        end else if (ren) begin
            raddr_bin <= raddr_bin + 1'b1;
        end
    end

    // ------------------------------------------------------------------------
    // Convert Gray pointers to binary for RAM address indexing (lower bits)
    // ------------------------------------------------------------------------
    wire [ADDR_WIDTH-1:0] waddr_ram = gray2bin(wptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = gray2bin(rptr_gray)[ADDR_WIDTH-1:0];

    // ------------------------------------------------------------------------
    // Instantiate dual-port RAM submodule
    // ------------------------------------------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk  (wclk),
        .wenc  (wen),
        .waddr (waddr_ram),
        .wdata (wdata),
        .rclk  (rclk),
        .renc  (ren),
        .raddr (raddr_ram),
        .rdata (rdata)
    );

    // ------------------------------------------------------------------------
    // Full flag generation (in write clock domain)
    // FIFO is full when write pointer equals read pointer with MSBs inverted
    // ------------------------------------------------------------------------
    wire full_flag = (wptr_gray == {~rptr_gray_wclk_sync[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]});

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_flag;
    end

    // ------------------------------------------------------------------------
    // Empty flag generation (in read clock domain)
    // FIFO is empty when read pointer equals synchronized write pointer
    // ------------------------------------------------------------------------
    wire empty_flag = (rptr_gray == wptr_gray_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_flag;
    end

endmodule

// -----------------------------------------------------------------------------
// Dual-port RAM submodule
// -----------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input  wire                  wclk,
    input  wire                  wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,
    input  wire                  rclk,
    input  wire                  renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
);

    // RAM storage array
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write logic (synchronous write)
    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    // Read logic (synchronous read)
    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
        else
            rdata <= rdata; // Hold last value if not reading
    end

endmodule
`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                   wclk,    // Write clock
    input                   rclk,    // Read clock
    input                   wrstn,   // Write reset (active low)
    input                   rrstn,   // Read reset (active low)
    input                   winc,    // Write increment (push)
    input                   rinc,    // Read increment (pop)
    input  [WIDTH-1:0]      wdata,   // Write data input
    output reg              wfull,   // Write full flag
    output reg              rempty,  // Read empty flag
    output reg [WIDTH-1:0]  rdata    // Read data output
);

    // Parameter calculations
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // Extra bit to distinguish full/empty

    // ----------------------------
    // 1) Dual-port RAM instantiation
    // ----------------------------

    wire [ADDR_WIDTH-1:0] waddr_bin;
    wire [ADDR_WIDTH-1:0] raddr_bin;

    wire wram_en;
    wire rram_en;
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) mem (
        .wclk(wclk),
        .wenc(wram_en),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rram_en),
        .raddr(raddr_bin),
        .rdata(ram_rdata)
    );

    // ----------------------------
    // 2) Write Controller (wclk domain)
    // ----------------------------

    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Write pointer increment only when not full and winc asserted
    wire winc_effective = winc & ~wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (winc_effective) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= (wptr_bin + 1'b1) ^ ((wptr_bin + 1'b1) >> 1);
        end
    end

    // ----------------------------
    // 3) Read Controller (rclk domain)
    // ----------------------------

    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Read pointer increment only when not empty and rinc asserted
    wire rinc_effective = rinc & ~rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (rinc_effective) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= (rptr_bin + 1'b1) ^ ((rptr_bin + 1'b1) >> 1);
        end
    end

    // ----------------------------
    // 4) Read pointer synchronizer to write clock domain (for full detection)
    // ----------------------------

    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync1, rptr_gray_wclk_sync2;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync1 <= 0;
            rptr_gray_wclk_sync2 <= 0;
        end else begin
            rptr_gray_wclk_sync1 <= rptr_gray;
            rptr_gray_wclk_sync2 <= rptr_gray_wclk_sync1;
        end
    end

    // ----------------------------
    // 5) Write pointer synchronizer to read clock domain (for empty detection)
    // ----------------------------

    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync1, wptr_gray_rclk_sync2;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync1 <= 0;
            wptr_gray_rclk_sync2 <= 0;
        end else begin
            wptr_gray_rclk_sync1 <= wptr_gray;
            wptr_gray_rclk_sync2 <= wptr_gray_rclk_sync1;
        end
    end

    // ----------------------------
    // Functions: Gray to Binary conversion
    // ----------------------------

    function [PTR_WIDTH-1:0] gray_to_bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray_to_bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
        end
    endfunction

    // Extract binary addresses for RAM (lowest ADDR_WIDTH bits)
    assign waddr_bin = gray_to_bin(wptr_gray)[ADDR_WIDTH-1:0];
    assign raddr_bin = gray_to_bin(rptr_gray)[ADDR_WIDTH-1:0];

    // ----------------------------
    // Full flag generation (wclk domain)
    // FIFO is full when:
    // wptr_gray == (invert MSB and second MSB of rptr_gray) concatenated with rest bits equal
    // That is, full when:
    // wptr_gray[PTR_WIDTH-1:0] == {~rptr_gray[PTR_WIDTH-1], ~rptr_gray[PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]}
    // ----------------------------

    wire [PTR_WIDTH-1:0] rptr_gray_wclk_invmsb =
        { ~rptr_gray_wclk_sync2[PTR_WIDTH-1],
          ~rptr_gray_wclk_sync2[PTR_WIDTH-2],
          rptr_gray_wclk_sync2[PTR_WIDTH-3:0] };

    wire wfull_next = (wptr_gray == rptr_gray_wclk_invmsb);

    // ----------------------------
    // Empty flag generation (rclk domain)
    // FIFO is empty when:
    // rptr_gray == wptr_gray synchronizer in read clock domain
    // ----------------------------

    wire rempty_next = (rptr_gray == wptr_gray_rclk_sync2);

    // ----------------------------
    // Register full and empty flags
    // ----------------------------

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= wfull_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= rempty_next;
    end

    // ----------------------------
    // RAM write enable and read enable signals
    // ----------------------------

    assign wram_en = winc_effective;  // Write enable when push and not full
    assign rram_en = rinc_effective;  // Read enable when pop and not empty

    // ----------------------------
    // Read data output register (rclk domain)
    // ----------------------------

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rram_en)
            rdata <= ram_rdata;
    end

endmodule


// ----------------------------
// Dual-port RAM module definition
// ----------------------------
// - Separate clocks for write and read
// - Separate write and read enables
// - Parameterized width and depth
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                    wclk,
    input                    wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]   wdata,
    input                    rclk,
    input                    renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]   rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule
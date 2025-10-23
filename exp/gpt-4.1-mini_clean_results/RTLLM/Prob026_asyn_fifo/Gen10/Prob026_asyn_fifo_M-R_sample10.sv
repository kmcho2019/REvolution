`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,    // Active-low reset for write domain
    input                  rrstn,    // Active-low reset for read domain
    input                  winc,     // Write increment enable
    input                  rinc,     // Read increment enable
    input  [WIDTH-1:0]     wdata,    // Write data input
    output                 wfull,    // Write full flag
    output                 rempty,   // Read empty flag
    output reg [WIDTH-1:0] rdata     // Read data output
);

    // Parameter calculations for pointer widths
    localparam PTR_WIDTH = (DEPTH > 1) ? $clog2(DEPTH) : 1;
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1; // One extra MSB for full detection

    // -----------------------------
    // Binary pointers in each clock domain (synchronous registers)
    reg [PTR_EXT_WIDTH-1:0] wptr_bin;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin;

    // Next pointers (combinational)
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc & ~wfull);
    wire [PTR_EXT_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc & ~rempty);

    // -----------------------------
    // Gray code conversion (combinational)
    wire [PTR_EXT_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_EXT_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // -----------------------------
    // Synchronization of pointers crossing clock domains
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk;

    sync_gray #(.WIDTH(PTR_EXT_WIDTH)) rptr_sync_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in_gray(rptr_gray),
        .out_gray(rptr_gray_sync_wclk)
    );

    sync_gray #(.WIDTH(PTR_EXT_WIDTH)) wptr_sync_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in_gray(wptr_gray),
        .out_gray(wptr_gray_sync_rclk)
    );

    // Convert synchronized Gray pointers back to binary for full/empty detection
    wire [PTR_EXT_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    // -----------------------------
    // Write domain logic: pointer increment and write enable gated by full
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc & ~wfull) begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // Read domain logic: pointer increment gated by empty
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rdata <= {WIDTH{1'b0}};
        end else begin
            if (rinc & ~rempty) begin
                rptr_bin <= rptr_bin_next;
                // Read data from RAM at new read address will be registered below
            end
            if (rinc & ~rempty) begin
                // rdata updated in separate always block below using RAM output
                // To avoid combinational loop, rdata update moved below
                // See note below
            end
        end
    end

    // -----------------------------
    // Generate full signal in write clock domain
    // Full when next write pointer equals read pointer synchronized to write domain
    // with MSB and MSB-1 inverted, others equal
    assign wfull =
        (wptr_bin_next[PTR_EXT_WIDTH-1:PTR_EXT_WIDTH-2] == ~rptr_bin_sync_wclk[PTR_EXT_WIDTH-1:PTR_EXT_WIDTH-2])
        && (wptr_bin_next[PTR_EXT_WIDTH-3:0] == rptr_bin_sync_wclk[PTR_EXT_WIDTH-3:0]);

    // Generate empty signal in read clock domain
    // Empty when read pointer equals write pointer synchronized to read domain
    assign rempty = (rptr_bin == wptr_bin_sync_rclk);

    // -----------------------------
    // Addresses for RAM
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // -----------------------------
    // Instantiate asynchronous dual-port RAM
    wire [WIDTH-1:0] ram_rdata;

    asyn_fifo_dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(winc & ~wfull),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & ~rempty),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Register read data on rclk when rinc & ~rempty asserted
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rinc & ~rempty)
            rdata <= ram_rdata;
    end

    // -----------------------------
    // Functions for Gray code conversions (pure combinational, no loops)

    // Binary to Gray code
    function [PTR_EXT_WIDTH-1:0] bin2gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for (i = PTR_EXT_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to binary code
    function [PTR_EXT_WIDTH-1:0] gray2bin;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j = PTR_EXT_WIDTH-2; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

endmodule


// ---------------------------------------------
// Synchronize Gray-coded multi-bit signals crossing clock domains
module sync_gray #(
    parameter WIDTH = 4
)(
    input  clk,
    input  rst_n,
    input  [WIDTH-1:0] in_gray,
    output reg [WIDTH-1:0] out_gray
);

    reg [WIDTH-1:0] sync_ff;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff <= {WIDTH{1'b0}};
            out_gray <= {WIDTH{1'b0}};
        end else begin
            sync_ff <= in_gray;
            out_gray <= sync_ff;
        end
    end

endmodule


// ---------------------------------------------
// Asynchronous dual-port RAM: separate clocks for read/write
module asyn_fifo_dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                      rclk,
    input                      renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
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
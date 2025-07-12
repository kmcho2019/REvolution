`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low write reset
    input                   rrstn,      // active low read reset
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output reg              wfull,
    output reg              rempty,
    output reg [WIDTH-1:0]  rdata
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ---------- Binary pointers ----------
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // ---------- Gray pointers (generated on the fly) ----------
    wire [PTR_WIDTH-1:0] wptr_gray = binary_to_gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = binary_to_gray(rptr_bin);

    // ---------- Synchronize rptr_gray into wclk domain ----------
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= {PTR_WIDTH{1'b0}};
            rptr_gray_wclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // ---------- Synchronize wptr_gray into rclk domain ----------
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= {PTR_WIDTH{1'b0}};
            wptr_gray_rclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // ---------- Convert synchronized Gray pointers back to binary ----------
    wire [PTR_WIDTH-1:0] rptr_sync_bin_wclk = gray_to_binary(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] wptr_sync_bin_rclk = gray_to_binary(wptr_gray_rclk_sync);

    // ---------- Full detection logic ----------
    // Prepare next write pointer in binary and Gray
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = binary_to_gray(wptr_bin_next);

    wire full_condition =
        (wptr_gray_next[PTR_WIDTH-1]   == ~rptr_gray_wclk_sync[PTR_WIDTH-1]) &&
        (wptr_gray_next[PTR_WIDTH-2]   == ~rptr_gray_wclk_sync[PTR_WIDTH-2]) &&
        (wptr_gray_next[PTR_WIDTH-3:0] ==  rptr_gray_wclk_sync[PTR_WIDTH-3:0]);

    // ---------- Write pointer and full flag update ----------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= {PTR_WIDTH{1'b0}};
            wfull <= 1'b0;
        end else begin
            wfull <= full_condition;
            if (winc && !wfull) begin
                wptr_bin <= wptr_bin_next;
            end
        end
    end

    // ---------- Empty flag and read pointer update ----------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= {PTR_WIDTH{1'b0}};
            rempty <= 1'b1;
            rdata <= {WIDTH{1'b0}};
        end else begin
            rempty <= (rptr_gray == wptr_gray_rclk_sync);
            if (rinc && !rempty) begin
                rptr_bin <= rptr_bin + 1'b1;
            end
            // rdata updated below
        end
    end

    // ---------- RAM interfaces ----------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    wire [WIDTH-1:0] ram_rdata;

    // Register RAM read data on rclk for stable output
    always @(posedge rclk) begin
        if (r_en)
            rdata <= ram_rdata;
    end

    // ---------- Instantiate dual-port RAM ----------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // ---------- Functions ----------
    // Binary to Gray code conversion (PTR_WIDTH bits)
    function [PTR_WIDTH-1:0] binary_to_gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            binary_to_gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1)
                binary_to_gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to binary conversion (PTR_WIDTH bits)
    function [PTR_WIDTH-1:0] gray_to_binary;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray_to_binary[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1)
                gray_to_binary[i] = gray_to_binary[i+1] ^ gray[i];
        end
    endfunction

endmodule


// -------------------------
// Dual-port RAM with independent clocks and enables
// -------------------------
module dual_port_RAM #(
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

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end
endmodule
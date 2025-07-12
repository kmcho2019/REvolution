`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low reset for write domain
    input                   rrstn,      // active low reset for read domain
    input                   winc,       // write increment (push) enable
    input                   rinc,       // read increment (pop) enable
    input  [WIDTH-1:0]      wdata,      // data input for write
    output                  wfull,      // FIFO full flag (write domain)
    output                  rempty,     // FIFO empty flag (read domain)
    output [WIDTH-1:0]      rdata       // data output for read
);

    // Compute address and pointer width based on depth
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // One extra bit for full detection

    // --- Binary write and read pointers ---
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // --- Gray code conversion functions ---
    // Binary to Gray code
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Gray to Binary code
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Current Gray pointers
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // --- Synchronize read pointer into write clock domain ---
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync1, rptr_gray_wclk_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_wclk_sync2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_sync1 <= rptr_gray;
            rptr_gray_wclk_sync2 <= rptr_gray_wclk_sync1;
        end
    end

    // --- Synchronize write pointer into read clock domain ---
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync1, wptr_gray_rclk_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_rclk_sync2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_sync1 <= wptr_gray;
            wptr_gray_rclk_sync2 <= wptr_gray_rclk_sync1;
        end
    end

    // Convert synchronized Gray pointers back to binary
    wire [PTR_WIDTH-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk_sync2);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk_sync2);

    // --- Write pointer logic ---
    wire wfull_next;

    // Compute next write pointer if write increment and not full
    wire [PTR_WIDTH-1:0] wptr_bin_next = (winc && !wfull) ? (wptr_bin + 1'b1) : wptr_bin;

    // Full condition: when next write pointer equals read pointer with MSBs inverted
    // Condition: wptr_gray_next == {~rptr_gray[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]}
    // Implement full condition combinationally
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);
    wire full_cond;
    assign full_cond = (wptr_gray_next[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_wclk_sync2[PTR_WIDTH-1:PTR_WIDTH-2]) &&
                       (wptr_gray_next[PTR_WIDTH-3:0] == rptr_gray_wclk_sync2[PTR_WIDTH-3:0]);

    assign wfull_next = full_cond;

    // Register write pointer with synchronous reset
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= {PTR_WIDTH{1'b0}};
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1'b1;
        end
    end

    // --- Read pointer logic ---
    wire rempty_next;

    // Empty condition: read pointer equals synchronized write pointer
    assign rempty_next = (rptr_gray == wptr_gray_rclk_sync2);

    // Compute next read pointer if read increment and not empty
    wire [PTR_WIDTH-1:0] rptr_bin_next = (rinc && !rempty) ? (rptr_bin + 1'b1) : rptr_bin;

    // Register read pointer with synchronous reset
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= {PTR_WIDTH{1'b0}};
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1'b1;
        end
    end

    // --- Outputs ---
    assign wfull = wfull_next;
    assign rempty = rempty_next;

    // RAM addresses are lower bits of pointers (binary pointers)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM enables: write enable only when winc and not full; read enable when rinc and not empty
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // Read data from RAM
    wire [WIDTH-1:0] ram_rdata;

    // Register output data on read clock only when reading
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata_reg <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata_reg <= ram_rdata;
        end
    end

    assign rdata = rdata_reg;

    // --- Dual-port RAM instantiation ---
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

endmodule


// Dual-port RAM module: parameterized depth and width
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]         wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation (synchronous)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read operation (synchronous)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule
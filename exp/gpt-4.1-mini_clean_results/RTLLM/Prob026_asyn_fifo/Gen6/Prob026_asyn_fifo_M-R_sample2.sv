`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input               wclk,
    input               rclk,
    input               wrstn, // active low reset for write domain
    input               rrstn, // active low reset for read domain
    input               winc,
    input               rinc,
    input      [WIDTH-1:0] wdata,
    output              wfull,
    output              rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam GRAY_WIDTH = PTR_WIDTH + 1;

    // ----- Gray code conversion functions -----
    function automatic [GRAY_WIDTH-1:0] bin2gray(input [PTR_WIDTH:0] bin);
        integer i;
        begin
            bin2gray[GRAY_WIDTH-1] = bin[PTR_WIDTH];
            for (i = GRAY_WIDTH-2; i >= 0; i=i-1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    function automatic [PTR_WIDTH:0] gray2bin(input [GRAY_WIDTH-1:0] gray);
        integer j;
        begin
            gray2bin[PTR_WIDTH] = gray[GRAY_WIDTH-1];
            for (j = PTR_WIDTH-1; j >= 0; j=j-1) begin
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
            end
        end
    endfunction

    // ----- Binary pointers in respective clock domains -----
    reg [PTR_WIDTH:0] wptr_bin, rptr_bin;
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + ((winc && !wfull) ? 1'b1 : 1'b0);
    wire [PTR_WIDTH:0] rptr_bin_next = rptr_bin + ((rinc && !rempty) ? 1'b1 : 1'b0);

    // ----- Gray pointers for pointer crossing -----
    reg [GRAY_WIDTH-1:0] wptr_gray, rptr_gray;

    // ----- Write pointer update (write clock domain) -----
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // ----- Read pointer update (read clock domain) -----
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // ----- Synchronizer modules for pointer crossing -----
    wire [GRAY_WIDTH-1:0] rptr_gray_sync_wclk; // read pointer synchronized to write clock domain
    wire [GRAY_WIDTH-1:0] wptr_gray_sync_rclk; // write pointer synchronized to read clock domain

    sync_gray #(
        .WIDTH(GRAY_WIDTH)
    ) rptr_sync_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .gray_in(rptr_gray),
        .gray_out(rptr_gray_sync_wclk)
    );

    sync_gray #(
        .WIDTH(GRAY_WIDTH)
    ) wptr_sync_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .gray_in(wptr_gray),
        .gray_out(wptr_gray_sync_rclk)
    );

    // ----- Full and empty logic -----
    // Condition for full:
    // next write pointer equals read pointer synchronized into write clock domain with MSB and MSB-1 inverted
    wire full_cond_msb_invert = (bin2gray(wptr_bin_next)[GRAY_WIDTH-1] != rptr_gray_sync_wclk[GRAY_WIDTH-1]) &&
                               (bin2gray(wptr_bin_next)[GRAY_WIDTH-2] != rptr_gray_sync_wclk[GRAY_WIDTH-2]);
    wire full_cond_lsb_equal = (bin2gray(wptr_bin_next)[GRAY_WIDTH-3:0] == rptr_gray_sync_wclk[GRAY_WIDTH-3:0]);

    assign wfull = full_cond_msb_invert && full_cond_lsb_equal;

    // Condition for empty: read pointer equals write pointer synchronized into read clock domain
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // ----- Addresses for RAM are lower PTR_WIDTH bits of binary pointers -----
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write and read enable signals for RAM
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // ----- Instantiate dual-port RAM -----
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_RAM_inst (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // ----- Register read data on read clock domain -----
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end


endmodule

// ---------------------
// Two-stage synchronizer for Gray code pointers
// ---------------------
module sync_gray #(
    parameter WIDTH = 5
)(
    input  wire             clk,
    input  wire             rstn,     // active low reset
    input  wire [WIDTH-1:0] gray_in,
    output reg  [WIDTH-1:0] gray_out
);

    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= 0;
            gray_out <= 0;
        end else begin
            sync_ff1 <= gray_in;
            gray_out <= sync_ff1;
        end
    end

endmodule


// ---------------------
// Dual-port RAM module with separate clocks for write and read
// ---------------------
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

    // Memory array
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
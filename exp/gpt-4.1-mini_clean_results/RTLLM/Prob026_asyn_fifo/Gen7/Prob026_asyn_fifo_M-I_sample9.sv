`timescale 1ns / 1ps

// Dual-port RAM with independent read/write clocks and enables
// Parameterized width and depth
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                   wclk,
    input  wire                   wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]       wdata,
    input  wire                   rclk,
    input  wire                   renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]       rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write Port
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read Port: output updated only when renc is asserted
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
        // Otherwise, rdata holds previous value implicitly
    end

endmodule


// Two-stage synchronizer for Gray code pointer crossing clock domains
module sync_gray #(
    parameter WIDTH = 5
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire [WIDTH-1:0] data_in,
    output reg  [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_stage1 <= {WIDTH{1'b0}};
            data_out   <= {WIDTH{1'b0}};
        end else begin
            sync_stage1 <= data_in;
            data_out   <= sync_stage1;
        end
    end
endmodule


// Asynchronous FIFO with parameterizable width and depth
// Implements dual-port RAM storage, Gray-coded pointers, pointer synchronizers,
// and full/empty status signals.
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1  // Pointer width for Gray code (one extra bit)
)(
    input  wire                 wclk,      // Write clock
    input  wire                 rclk,      // Read clock
    input  wire                 wrstn,     // Write reset (active low)
    input  wire                 rrstn,     // Read reset (active low)
    input  wire                 winc,      // Write increment (push)
    input  wire                 rinc,      // Read increment (pop)
    input  wire [WIDTH-1:0]     wdata,     // Write data input
    output reg                  wfull,     // FIFO full flag (write domain)
    output reg                  rempty,    // FIFO empty flag (read domain)
    output wire [WIDTH-1:0]     rdata      // Read data output
);

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray-coded pointers
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronized Gray pointers across clock domains
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk; // Read pointer synchronized into write clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk; // Write pointer synchronized into read clock domain

    // Convert binary to Gray code
    function automatic [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Convert Gray code to binary
    function automatic [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    // Write enable: only when not full and write increment requested
    wire wen = winc & ~wfull;

    // Write pointer logic (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read enable: only when not empty and read increment requested
    wire ren = rinc & ~rempty;

    // Read pointer logic (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer (Gray) into write clock domain
    sync_gray #(
        .WIDTH(PTR_WIDTH)
    ) sync_rptr_inst (
        .clk(wclk),
        .rst_n(wrstn),
        .data_in(rptr_gray),
        .data_out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer (Gray) into read clock domain
    sync_gray #(
        .WIDTH(PTR_WIDTH)
    ) sync_wptr_inst (
        .clk(rclk),
        .rst_n(rrstn),
        .data_in(wptr_gray),
        .data_out(wptr_gray_sync_rclk)
    );

    // Extract RAM addresses from lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Full condition logic (in write clock domain)
    // FIFO full when write pointer == read pointer with MSB two bits inverted
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk_inv = {
        ~rptr_gray_sync_wclk[PTR_WIDTH-1],
        ~rptr_gray_sync_wclk[PTR_WIDTH-2],
        rptr_gray_sync_wclk[PTR_WIDTH-3:0]
    };

    wire full_next = (wptr_gray == rptr_gray_sync_wclk_inv);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_next;
    end

    // Empty condition logic (in read clock domain)
    wire empty_next = (rptr_gray == wptr_gray_sync_rclk);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;  // FIFO empty at reset
        else
            rempty <= empty_next;
    end

endmodule
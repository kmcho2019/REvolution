`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH  = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // Active low asynchronous reset for write domain
    input                   rrstn,   // Active low asynchronous reset for read domain
    input                   winc,    // Write increment
    input                   rinc,    // Read increment
    input      [WIDTH-1:0]  wdata,
    output reg              wfull,   // Write full flag, registered for stability
    output reg              rempty,  // Read empty flag, registered for stability
    output reg [WIDTH-1:0]  rdata
);

    // Calculate pointer width based on depth (must be power of two)
    localparam PTR_WIDTH     = $clog2(DEPTH);
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1; // Extra MSB for full/empty pointer wrap detection

    // Binary pointers (PTR_EXT_WIDTH bits)
    reg [PTR_EXT_WIDTH-1:0] wptr_bin;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin;

    // Gray code pointers (converted from binary pointers)
    wire [PTR_EXT_WIDTH-1:0] wptr_gray;
    wire [PTR_EXT_WIDTH-1:0] rptr_gray;

    // Synchronized Gray pointers crossing clock domains
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk; // Read pointer synchronized into write clk domain
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk; // Write pointer synchronized into read clk domain

    // Write and read enables gated by full and empty signals
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM addresses are lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // RAM output data wire
    wire [WIDTH-1:0] ram_rdata;

    // Binary to Gray code conversion function
    function [PTR_EXT_WIDTH-1:0] binary_to_gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            binary_to_gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for (i = PTR_EXT_WIDTH-2; i >= 0; i = i - 1) begin
                binary_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Gray code to binary conversion function
    function [PTR_EXT_WIDTH-1:0] gray_to_binary;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray_to_binary[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j = PTR_EXT_WIDTH-2; j >= 0; j = j - 1) begin
                gray_to_binary[j] = gray_to_binary[j+1] ^ gray[j];
            end
        end
    endfunction

    // Write pointer binary logic: increment on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) 
            wptr_bin <= 0;
        else if (w_en) 
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer binary logic: increment on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) 
            rptr_bin <= 0;
        else if (r_en) 
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Current Gray pointers conversion from binary pointers
    assign wptr_gray = binary_to_gray(wptr_bin);
    assign rptr_gray = binary_to_gray(rptr_bin);

    // Two-stage synchronizers for crossing clock domains
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Calculate next write pointer binary and corresponding Gray code (for full detection)
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next  = wptr_bin + 1'b1;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = binary_to_gray(wptr_bin_next);

    // Full flag logic, registered in write clock domain to avoid glitches
    reg full_reg1, full_reg2;
    wire full_comb = (
        (wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_EXT_WIDTH-3:0]) &&
        (wptr_gray_next[PTR_EXT_WIDTH-1]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-1])   &&
        (wptr_gray_next[PTR_EXT_WIDTH-2]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-2])
    );
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            full_reg1 <= 1'b0;
            full_reg2 <= 1'b0;
            wfull     <= 1'b0;
        end else begin
            full_reg1 <= full_comb;
            full_reg2 <= full_reg1;
            wfull     <= full_reg2;
        end
    end

    // Empty flag logic, registered in read clock domain to avoid glitches
    reg empty_reg1, empty_reg2;
    wire empty_comb = (rptr_gray == wptr_gray_sync_rclk);
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            empty_reg1 <= 1'b1; // FIFO empty at reset
            empty_reg2 <= 1'b1;
            rempty    <= 1'b1;
        end else begin
            empty_reg1 <= empty_comb;
            empty_reg2 <= empty_reg1;
            rempty    <= empty_reg2;
        end
    end

    // Register read data on read clock domain when reading (r_en)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM submodule with unique name to avoid conflicts
    asyn_fifo_dual_port_ram #(
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


// Two-stage synchronizer for multi-bit signals crossing clock domains
module synchronizer #(
    parameter WIDTH = 4
)(
    input               clk,
    input               rst_n, // Active low synchronous reset
    input  [WIDTH-1:0]  in,
    output reg [WIDTH-1:0] out
);
    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk) begin
        if (!rst_n) begin
            sync_ff1 <= {WIDTH{1'b0}};
            out      <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= in;
            out      <= sync_ff1;
        end
    end
endmodule


// Dual-port RAM module for asynchronous FIFO storage with unique module name
module asyn_fifo_dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH  = 16
)(
    input                       wclk,
    input                       wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]      wdata,
    input                       rclk,
    input                       renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);
    // RAM memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port logic
    always @(posedge wclk) begin
        if (wenc) 
            mem[waddr] <= wdata;
    end

    // Read port logic
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule
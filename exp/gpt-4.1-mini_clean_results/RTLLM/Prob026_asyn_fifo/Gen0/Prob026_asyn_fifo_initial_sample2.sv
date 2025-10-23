`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    // Memory declaration
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if(wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    // For this asynchronous FIFO, data is valid on the next rclk after raddr changes and renc asserted
    always @(posedge rclk) begin
        if(renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end
endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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
    // Calculate pointer width (number of bits to address DEPTH)
    localparam PTR_WIDTH = $clog2(DEPTH);
    // For Gray code pointer, we keep PTR_WIDTH bits

    // Binary write and read pointers
    reg [PTR_WIDTH:0] waddr_bin; // extra bit for full detection (pointer wrap)
    reg [PTR_WIDTH:0] raddr_bin;

    // Gray code pointers
    reg [PTR_WIDTH:0] wptr;
    reg [PTR_WIDTH:0] rptr;

    // Synchronizers for pointers crossing clock domains
    reg [PTR_WIDTH:0] rptr_wclk_1, rptr_wclk_2; // rptr synchronized into wclk domain
    reg [PTR_WIDTH:0] wptr_rclk_1, wptr_rclk_2; // wptr synchronized into rclk domain

    wire [PTR_WIDTH:0] rptr_wclk; // synchronized read pointer in write clock domain
    wire [PTR_WIDTH:0] wptr_rclk; // synchronized write pointer in read clock domain

    // Write enable and read enable signals for RAM
    wire wen;
    wire ren;

    // Addresses for RAM access (lower PTR_WIDTH bits of binary pointers)
    wire [PTR_WIDTH-1:0] waddr_ram;
    wire [PTR_WIDTH-1:0] raddr_ram;

    // RAM data read out
    wire [WIDTH-1:0] ram_rdata;

    // Internal full and empty signals
    reg full_reg;
    reg empty_reg;

    // Functions for Gray code conversion and binary conversion:
    function [PTR_WIDTH:0] bin2gray;
        input [PTR_WIDTH:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH] = bin[PTR_WIDTH];
            for(i=PTR_WIDTH-1; i>=0; i=i-1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH:0] gray2bin;
        input [PTR_WIDTH:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for(i=PTR_WIDTH-1; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer binary increment on wclk
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else if (winc && !full_reg) begin
            waddr_bin <= waddr_bin + 1;
            wptr <= bin2gray(waddr_bin + 1);
        end else begin
            // Maintain current pointer if not writing or full
            wptr <= wptr;
            waddr_bin <= waddr_bin;
        end
    end

    // Read pointer binary increment on rclk
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else if (rinc && !empty_reg) begin
            raddr_bin <= raddr_bin + 1;
            rptr <= bin2gray(raddr_bin + 1);
        end else begin
            rptr <= rptr;
            raddr_bin <= raddr_bin;
        end
    end

    // Synchronize rptr (read pointer) into write clock domain with two-stage synchronizer
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn) begin
            rptr_wclk_1 <= 0;
            rptr_wclk_2 <= 0;
        end else begin
            rptr_wclk_1 <= rptr;
            rptr_wclk_2 <= rptr_wclk_1;
        end
    end

    // Synchronize wptr (write pointer) into read clock domain with two-stage synchronizer
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn) begin
            wptr_rclk_1 <= 0;
            wptr_rclk_2 <= 0;
        end else begin
            wptr_rclk_1 <= wptr;
            wptr_rclk_2 <= wptr_rclk_1;
        end
    end

    assign rptr_wclk = rptr_wclk_2;
    assign wptr_rclk = wptr_rclk_2;

    // Full flag logic:
    // FIFO full when:
    // write pointer next value == read pointer with the two MSBs inverted (to detect wraparound)
    // As per: when highest and second-highest bits are inverted, and rest bits equal.
    // Full condition uses Gray codes: full if wptr == {~rptr_wclk[PTR_WIDTH:PTR_WIDTH-1], rptr_wclk[PTR_WIDTH-2:0]}
    wire [PTR_WIDTH:0] rptr_wclk_inv;
    assign rptr_wclk_inv = {~rptr_wclk[PTR_WIDTH], ~rptr_wclk[PTR_WIDTH-1], rptr_wclk[PTR_WIDTH-2:0]};

    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn)
            full_reg <= 1'b0;
        else
            full_reg <= (wptr == rptr_wclk_inv);
    end

    // Empty flag logic:
    // FIFO empty when read pointer == synchronized write pointer
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            empty_reg <= 1'b1; // empty at reset
        else
            empty_reg <= (rptr == wptr_rclk);
    end

    assign wfull = full_reg;
    assign rempty = empty_reg;

    // RAM address assignments
    // Use lower PTR_WIDTH bits of binary pointers for addressing RAM
    assign waddr_ram = waddr_bin[PTR_WIDTH-1:0];
    assign raddr_ram = raddr_bin[PTR_WIDTH-1:0];

    // RAM write enable and read enable
    assign wen = winc & ~full_reg;
    assign ren = rinc & ~empty_reg;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_ram),
        .rdata(ram_rdata)
    );

    assign rdata = ram_rdata;

endmodule
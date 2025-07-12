`timescale 1ns / 1ps

// Dual-port RAM module with separate read and write clocks
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                     wclk,
    input  wire                     wenc,
    input  wire [ADDR_WIDTH-1:0]   waddr,
    input  wire [WIDTH-1:0]         wdata,

    input  wire                     rclk,
    input  wire                     renc,
    input  wire [ADDR_WIDTH-1:0]   raddr,
    output reg  [WIDTH-1:0]         rdata
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


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire                wclk,
    input  wire                rclk,
    input  wire                wrstn,
    input  wire                rrstn,
    input  wire                winc,
    input  wire                rinc,
    input  wire [WIDTH-1:0]    wdata,
    output wire                wfull,
    output wire                rempty,
    output wire [WIDTH-1:0]    rdata
);

    // Binary pointers - registers updated synchronously
    reg [PTR_WIDTH-1:0] wbin_reg, rbin_reg;
    // Gray code pointers - registers updated synchronously
    reg [PTR_WIDTH-1:0] wgray_reg, rgray_reg;

    // Synchronizers for pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rgray_wclk_sync0, rgray_wclk_sync1;
    reg [PTR_WIDTH-1:0] wgray_rclk_sync0, wgray_rclk_sync1;

    // Binary to gray conversion function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to binary conversion function
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Combinational next pointer logic: binary pointers increment only if not full/empty and inc asserted
    wire winc_valid = winc & ~wfull;
    wire rinc_valid = rinc & ~rempty;

    wire [PTR_WIDTH-1:0] wbin_next = wbin_reg + winc_valid;
    wire [PTR_WIDTH-1:0] rbin_next = rbin_reg + rinc_valid;

    wire [PTR_WIDTH-1:0] wgray_next = bin2gray(wbin_next);
    wire [PTR_WIDTH-1:0] rgray_next = bin2gray(rbin_next);

    // Write pointer update on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin_reg  <= {PTR_WIDTH{1'b0}};
            wgray_reg <= {PTR_WIDTH{1'b0}};
        end else begin
            wbin_reg  <= wbin_next;
            wgray_reg <= wgray_next;
        end
    end

    // Read pointer update on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin_reg  <= {PTR_WIDTH{1'b0}};
            rgray_reg <= {PTR_WIDTH{1'b0}};
        end else begin
            rbin_reg  <= rbin_next;
            rgray_reg <= rgray_next;
        end
    end

    // Synchronize read pointer into write clock domain (two stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rgray_wclk_sync0 <= {PTR_WIDTH{1'b0}};
            rgray_wclk_sync1 <= {PTR_WIDTH{1'b0}};
        end else begin
            rgray_wclk_sync0 <= rgray_reg;
            rgray_wclk_sync1 <= rgray_wclk_sync0;
        end
    end

    // Synchronize write pointer into read clock domain (two stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wgray_rclk_sync0 <= {PTR_WIDTH{1'b0}};
            wgray_rclk_sync1 <= {PTR_WIDTH{1'b0}};
        end else begin
            wgray_rclk_sync0 <= wgray_reg;
            wgray_rclk_sync1 <= wgray_rclk_sync0;
        end
    end

    // Convert synchronized gray pointers back to binary for address and empty/full logic
    wire [PTR_WIDTH-1:0] rbin_sync_in_wclk = gray2bin(rgray_wclk_sync1);
    wire [PTR_WIDTH-1:0] wbin_sync_in_rclk = gray2bin(wgray_rclk_sync1);

    // RAM addresses: use lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wbin_reg[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin_reg[ADDR_WIDTH-1:0];

    // RAM enable signals based on valid inc and not full/empty
    wire wen = winc_valid;
    wire ren = rinc_valid;

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

    // FIFO full condition:
    // Full when write pointer's MSB and second MSB bits are inverse of read pointer's MSB bits,
    // and the rest lower bits are equal.
    // Formally: wgray == {~rgray_msb, ~rgray_msb-1, rgray_lower_bits}
    wire [PTR_WIDTH-1:0] rgray_sync_in_wclk = rgray_wclk_sync1;
    wire full_condition = (wgray_reg == 
                           {~rgray_sync_in_wclk[PTR_WIDTH-1],
                            ~rgray_sync_in_wclk[PTR_WIDTH-2],
                            rgray_sync_in_wclk[PTR_WIDTH-3:0]});
    assign wfull = full_condition;

    // FIFO empty condition: when read pointer == synchronized write pointer in read clock domain
    assign rempty = (rgray_reg == wgray_rclk_sync1);

endmodule
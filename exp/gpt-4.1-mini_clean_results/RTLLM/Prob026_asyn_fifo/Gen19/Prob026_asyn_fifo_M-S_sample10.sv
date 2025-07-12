`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input              wclk,
    input              rclk,
    input              wrstn,   // active low write reset
    input              rrstn,   // active low read reset
    input              winc,
    input              rinc,
    input  [WIDTH-1:0] wdata,
    output             wfull,
    output             rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Write pointer binary and gray
    reg [ADDR_WIDTH:0] wbin = 0, wgray = 0;
    wire [ADDR_WIDTH:0] wbin_next = wbin + (winc && !wfull);
    wire [ADDR_WIDTH:0] wgray_next = (wbin_next >> 1) ^ wbin_next;

    // Read pointer binary and gray
    reg [ADDR_WIDTH:0] rbin = 0, rgray = 0;
    wire [ADDR_WIDTH:0] rbin_next = rbin + (rinc && !rempty);
    wire [ADDR_WIDTH:0] rgray_next = (rbin_next >> 1) ^ rbin_next;

    // Synchronize rgray into wclk domain
    reg [ADDR_WIDTH:0] rgray_wclk_ff1 = 0, rgray_wclk_ff2 = 0;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rgray_wclk_ff1 <= 0;
            rgray_wclk_ff2 <= 0;
        end else begin
            rgray_wclk_ff1 <= rgray;
            rgray_wclk_ff2 <= rgray_wclk_ff1;
        end
    end

    // Synchronize wgray into rclk domain
    reg [ADDR_WIDTH:0] wgray_rclk_ff1 = 0, wgray_rclk_ff2 = 0;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wgray_rclk_ff1 <= 0;
            wgray_rclk_ff2 <= 0;
        end else begin
            wgray_rclk_ff1 <= wgray;
            wgray_rclk_ff2 <= wgray_rclk_ff1;
        end
    end

    // Binary conversion function from Gray code (for addresses)
    function [ADDR_WIDTH-1:0] gray2bin;
        input [ADDR_WIDTH:0] gray;
        integer i;
        reg [ADDR_WIDTH:0] bin_tmp;
        begin
            bin_tmp[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i=i-1) begin
                bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
            end
            gray2bin = bin_tmp[ADDR_WIDTH-1:0];
        end
    endfunction

    // RAM memory implemented internally
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write pointer binary lower bits for RAM address
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    // Read pointer binary lower bits for RAM address
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // Write enable when winc and not full
    wire wen = winc && !wfull;
    // Read enable when rinc and not empty
    wire ren = rinc && !rempty;

    // Write port
    always @(posedge wclk) begin
        if (!wrstn) begin
            // No reset for RAM content required
        end else if (wen) begin
            ram_mem[waddr] <= wdata;
        end
    end

    // Read port data and register output
    reg [WIDTH-1:0] rdata_reg = {WIDTH{1'b0}};
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata_reg <= {WIDTH{1'b0}};
        end else if (ren) begin
            rdata_reg <= ram_mem[raddr];
        end
    end
    assign rdata = rdata_reg;

    // Update write pointer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wgray <= 0;
        end else begin
            wbin <= wbin_next;
            wgray <= wgray_next;
        end
    end

    // Update read pointer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rgray <= 0;
        end else begin
            rbin <= rbin_next;
            rgray <= rgray_next;
        end
    end

    // Full logic (in write clock domain)
    // Full if next wgray equals inverted MSBs of rgray synchronized into wclk domain
    wire full_flag = (wgray_next[ADDR_WIDTH]     != rgray_wclk_ff2[ADDR_WIDTH])   &&
                     (wgray_next[ADDR_WIDTH-1]   != rgray_wclk_ff2[ADDR_WIDTH-1]) &&
                     (wgray_next[ADDR_WIDTH-2:0] == rgray_wclk_ff2[ADDR_WIDTH-2:0]);

    assign wfull = full_flag;

    // Empty logic (in read clock domain)
    // Empty if rgray equals synchronized wgray
    assign rempty = (rgray == wgray_rclk_ff2);

endmodule
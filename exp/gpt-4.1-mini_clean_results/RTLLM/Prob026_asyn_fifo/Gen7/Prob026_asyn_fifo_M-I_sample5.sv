`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    // Pointer width: address bits + 1 for wrap-around distinction
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1;

    // Write pointer binary and Gray
    reg [PTR_EXT_WIDTH-1:0] wptr_bin, wptr_gray;
    // Read pointer binary and Gray
    reg [PTR_EXT_WIDTH-1:0] rptr_bin, rptr_gray;

    // Synchronized pointers between clock domains
    reg [PTR_EXT_WIDTH-1:0] rptr_gray_wclk_1, rptr_gray_wclk_2;
    reg [PTR_EXT_WIDTH-1:0] wptr_gray_rclk_1, wptr_gray_rclk_2;

    // Write enable: only when not full
    wire w_en = winc & ~wfull;
    // Read enable: only when not empty
    wire r_en = rinc & ~rempty;

    // RAM addresses: lower bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Function: binary to Gray code
    function [PTR_EXT_WIDTH-1:0] bin2gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for(i=PTR_EXT_WIDTH-2; i>=0; i=i-1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Function: Gray to binary conversion
    function [PTR_EXT_WIDTH-1:0] gray2bin;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j=PTR_EXT_WIDTH-2; j>=0; j=j-1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

    // Write pointer logic with Gray code update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= {PTR_EXT_WIDTH{1'b0}};
            wptr_gray <= {PTR_EXT_WIDTH{1'b0}};
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer logic with Gray code update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= {PTR_EXT_WIDTH{1'b0}};
            rptr_gray <= {PTR_EXT_WIDTH{1'b0}};
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer Gray code into write clock domain (two-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_1 <= {PTR_EXT_WIDTH{1'b0}};
            rptr_gray_wclk_2 <= {PTR_EXT_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_1 <= rptr_gray;
            rptr_gray_wclk_2 <= rptr_gray_wclk_1;
        end
    end

    // Synchronize write pointer Gray code into read clock domain (two-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_1 <= {PTR_EXT_WIDTH{1'b0}};
            wptr_gray_rclk_2 <= {PTR_EXT_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_1 <= wptr_gray;
            wptr_gray_rclk_2 <= wptr_gray_rclk_1;
        end
    end

    // Next write pointer Gray code for full detection
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin + 1'b1);

    // Full condition:
    // When the next write pointer equals read pointer with MSB and second MSB inverted,
    // and remaining bits equal, FIFO is full
    assign wfull = ( (wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_wclk_2[PTR_EXT_WIDTH-3:0]) &&
                     (wptr_gray_next[PTR_EXT_WIDTH-1] != rptr_gray_wclk_2[PTR_EXT_WIDTH-1]) &&
                     (wptr_gray_next[PTR_EXT_WIDTH-2] != rptr_gray_wclk_2[PTR_EXT_WIDTH-2]) );

    // Empty condition: read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_2);

    // Register read data only on read enable for less switching
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate the dual-port RAM submodule
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
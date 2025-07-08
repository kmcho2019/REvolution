`timescale 1ns/1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);
    // RAM memory
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // hold last value if not reading
    end

endmodule

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
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    // Calculate address width (log2 of DEPTH)
    localparam ADDR_WIDTH = $clog2(DEPTH);
    // Pointer width for Gray code is ADDR_WIDTH + 1 to distinguish full/empty
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;

    // Gray-coded write and read pointers
    reg [PTR_WIDTH-1:0] wptr, rptr;

    // Synchronizers for pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_wclk1, rptr_wclk2; // rptr synchronized into wclk domain
    reg [PTR_WIDTH-1:0] wptr_rclk1, wptr_rclk2; // wptr synchronized into rclk domain

    // Buffer registers for previous pointers in their own clock domains (optional, can be used for stability)
    reg [PTR_WIDTH-1:0] wptr_buff;
    reg [PTR_WIDTH-1:0] rptr_buff;

    // Internal signals for RAM address
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable and read enable for RAM
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // RAM output data
    wire [WIDTH-1:0] ram_rdata;

    // Instantiate dual port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Function: Binary to Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Function: Gray code to Binary conversion
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

    // Write pointer binary and gray update on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
            if (wen) begin
                wptr_bin <= wptr_bin + 1'b1;
                wptr <= bin2gray(wptr_bin + 1'b1);
            end else begin
                wptr <= wptr; // hold gray pointer if no write
            end
        end
    end

    // Read pointer binary and gray update on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr;
            if (ren) begin
                rptr_bin <= rptr_bin + 1'b1;
                rptr <= bin2gray(rptr_bin + 1'b1);
            end else begin
                rptr <= rptr; // hold gray pointer if no read
            end
        end
    end

    // Synchronize read pointer (Gray) into wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_wclk1 <= 0;
            rptr_wclk2 <= 0;
        end else begin
            rptr_wclk1 <= rptr;
            rptr_wclk2 <= rptr_wclk1;
        end
    end

    // Synchronize write pointer (Gray) into rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_rclk1 <= 0;
            wptr_rclk2 <= 0;
        end else begin
            wptr_rclk1 <= wptr;
            wptr_rclk2 <= wptr_rclk1;
        end
    end

    // Convert synchronized Gray pointers back to binary for comparison in respective clock domains
    wire [PTR_WIDTH-1:0] rptr_wclk_bin = gray2bin(rptr_wclk2);
    wire [PTR_WIDTH-1:0] wptr_rclk_bin = gray2bin(wptr_rclk2);

    // Empty condition: when read pointer equals synchronized write pointer in rclk domain
    assign rempty = (rptr == wptr_rclk2);

    // Full condition: when write pointer equals read pointer with MSB bits inverted and rest same
    // According to given method:
    // FIFO full when:
    // wptr[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_wclk2[PTR_WIDTH-1:PTR_WIDTH-2]
    // and wptr[PTR_WIDTH-3:0] == rptr_wclk2[PTR_WIDTH-3:0]

    wire msb_inverted = (wptr[PTR_WIDTH-1] == ~rptr_wclk2[PTR_WIDTH-1]) && (wptr[PTR_WIDTH-2] == ~rptr_wclk2[PTR_WIDTH-2]);
    wire lsb_equal = (wptr[PTR_WIDTH-3:0] == rptr_wclk2[PTR_WIDTH-3:0]);

    assign wfull = msb_inverted && lsb_equal;

    // Output read data from RAM
    assign rdata = ram_rdata;

endmodule
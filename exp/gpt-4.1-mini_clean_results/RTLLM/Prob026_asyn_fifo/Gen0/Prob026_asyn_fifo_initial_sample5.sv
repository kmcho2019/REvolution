`timescale 1ns / 1ps
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input                      wclk,
    input                      wenc,
    input      [ADDR_WIDTH-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                      rclk,
    input                      renc,
    input      [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            // Hold previous data if no read enable
            rdata <= rdata;
        end
    end
endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1 // for Gray pointer MSB extension
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
    output     [WIDTH-1:0]  rdata
);

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] waddr_bin; // binary write pointer
    reg [PTR_WIDTH-1:0] raddr_bin; // binary read pointer

    // Gray code pointers
    reg [PTR_WIDTH-1:0] wptr, rptr;         // Local Gray pointers
    reg [PTR_WIDTH-1:0] wptr_rclk1, wptr_rclk2; // Write pointer synchronized into read clock domain
    reg [PTR_WIDTH-1:0] rptr_wclk1, rptr_wclk2; // Read pointer synchronized into write clock domain

    wire [PTR_WIDTH-1:0] wptr_rclk;          // Write pointer synchronized to read clock domain (output of sync)
    wire [PTR_WIDTH-1:0] rptr_wclk;          // Read pointer synchronized to write clock domain (output of sync)

    // Convert binary to Gray code function
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Convert Gray code to binary function
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Synchronizer for crossing write pointer into read clock domain (two-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_rclk1 <= {PTR_WIDTH{1'b0}};
            wptr_rclk2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_rclk1 <= wptr;
            wptr_rclk2 <= wptr_rclk1;
        end
    end
    assign wptr_rclk = wptr_rclk2;

    // Synchronizer for crossing read pointer into write clock domain (two-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_wclk1 <= {PTR_WIDTH{1'b0}};
            rptr_wclk2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_wclk1 <= rptr;
            rptr_wclk2 <= rptr_wclk1;
        end
    end
    assign rptr_wclk = rptr_wclk2;

    // Write pointer increment logic and Gray code update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= {PTR_WIDTH{1'b0}};
            wptr <= {PTR_WIDTH{1'b0}};
        end else begin
            // Only increment if write enable and not full
            if (winc && !wfull) begin
                waddr_bin <= waddr_bin + 1'b1;
            end
            wptr <= bin2gray(waddr_bin);
        end
    end

    // Read pointer increment logic and Gray code update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= {PTR_WIDTH{1'b0}};
            rptr <= {PTR_WIDTH{1'b0}};
        end else begin
            // Only increment if read enable and not empty
            if (rinc && !rempty) begin
                raddr_bin <= raddr_bin + 1'b1;
            end
            rptr <= bin2gray(raddr_bin);
        end
    end

    // Decode Gray code pointers to binary for addressing RAM
    wire [PTR_WIDTH-1:0] wptr_bin_sync = gray2bin(rptr_wclk);
    wire [PTR_WIDTH-1:0] rptr_bin_sync = gray2bin(wptr_rclk);

    // RAM address for read and write (lower bits of binary pointers)
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];

    // RAM read and write enables
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Full condition detection:
    // FIFO is full when:
    // The write pointer's MSB and next MSB bits are the inverse of the read pointer's corresponding bits,
    // and the rest of the bits are equal.
    // That is:
    // wptr[PTR_WIDTH-1:PTR_WIDTH-2] = ~rptr_wclk[PTR_WIDTH-1:PTR_WIDTH-2]
    // AND
    // wptr[PTR_WIDTH-3:0] == rptr_wclk[PTR_WIDTH-3:0]

    wire msb_inv_equal = (wptr[PTR_WIDTH-1]  == ~wptr_rclk[PTR_WIDTH-1]) &&
                         (wptr[PTR_WIDTH-2]  == ~wptr_rclk[PTR_WIDTH-2]);
    wire lower_bits_equal = (wptr[PTR_WIDTH-3:0] == wptr_rclk[PTR_WIDTH-3:0]);
    wire full_cond = msb_inv_equal && lower_bits_equal;

    assign wfull = full_cond;

    // Empty condition detection:
    // FIFO is empty when read pointer == write pointer synchronized into read clock domain
    assign rempty = (rptr == wptr_rclk);

endmodule
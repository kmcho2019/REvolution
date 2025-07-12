`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // active low write domain reset
    input                   rrstn,   // active low read domain reset
    input                   winc,    // write increment (push)
    input                   rinc,    // read increment (pop)
    input  [WIDTH-1:0]      wdata,   // data input
    output                  wfull,   // full flag (write domain)
    output                  rempty,  // empty flag (read domain)
    output [WIDTH-1:0]      rdata    // data output
);

    // Address width derived from DEPTH parameter
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // extra bit for full/empty detection

    // ------------------------------
    // Functions for Gray code conversion
    // ------------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] binary);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = binary[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = binary[i+1] ^ binary[i];
            end
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin_tmp;
        begin
            bin_tmp[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
            end
            gray2bin = bin_tmp;
        end
    endfunction

    // ------------------------------
    // Write pointer binary and Gray code
    // ------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + ((winc && !wfull) ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);

    // ------------------------------
    // Read pointer binary and Gray code
    // ------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + ((rinc && !rempty) ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // -----------------------------------------
    // Synchronize read pointer into write clock domain (2-stage)
    // -----------------------------------------
    reg [PTR_WIDTH-1:0] rptr_gray_sync_wclk1, rptr_gray_sync_wclk2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync_wclk2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync_wclk1 <= rptr_gray;
            rptr_gray_sync_wclk2 <= rptr_gray_sync_wclk1;
        end
    end

    // -----------------------------------------
    // Synchronize write pointer into read clock domain (2-stage)
    // -----------------------------------------
    reg [PTR_WIDTH-1:0] wptr_gray_sync_rclk1, wptr_gray_sync_rclk2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync_rclk2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync_rclk1 <= wptr_gray;
            wptr_gray_sync_rclk2 <= wptr_gray_sync_rclk1;
        end
    end

    // -----------------------------------------
    // Convert synchronized Gray pointers back to binary
    // -----------------------------------------
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk2);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk2);

    // -----------------------------------------
    // Full flag generation (write domain)
    // FIFO is full when:
    //   wptr_gray = {~rptr_gray_sync_wclk2[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync_wclk2[PTR_WIDTH-3:0]}
    // This means MSB and next MSB are inverted and rest bits equal
    // -----------------------------------------
    wire full_flag = (wptr_gray[PTR_WIDTH-1]    == ~rptr_gray_sync_wclk2[PTR_WIDTH-1]) &&
                     (wptr_gray[PTR_WIDTH-2]    == ~rptr_gray_sync_wclk2[PTR_WIDTH-2]) &&
                     (wptr_gray[PTR_WIDTH-3:0] ==  rptr_gray_sync_wclk2[PTR_WIDTH-3:0]);

    // -----------------------------------------
    // Empty flag generation (read domain)
    // FIFO is empty when:
    //   rptr_gray == synchronized wptr_gray in read domain
    // -----------------------------------------
    wire empty_flag = (rptr_gray == wptr_gray_sync_rclk2);

    // -------------------------------
    // Assign outputs
    // -------------------------------
    assign wfull = full_flag;
    assign rempty = empty_flag;

    // -------------------------------
    // Pointer updates on clocks and resets
    // -------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else
            wptr_bin <= wptr_bin_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else
            rptr_bin <= rptr_bin_next;
    end

    // -------------------------------
    // RAM address extraction (lowest ADDR_WIDTH bits)
    // -------------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write and read enables for RAM
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // -------------------------------
    // Instantiate dual-port RAM submodule
    // -------------------------------
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Output read data
    assign rdata = ram_rdata;

endmodule
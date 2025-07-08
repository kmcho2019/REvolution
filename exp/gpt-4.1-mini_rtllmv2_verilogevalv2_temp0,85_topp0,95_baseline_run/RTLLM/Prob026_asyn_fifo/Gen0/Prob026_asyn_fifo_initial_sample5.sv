`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                  wclk,
    input  wire                  rclk,
    input  wire                  wrstn,
    input  wire                  rrstn,
    input  wire                  winc,
    input  wire                  rinc,
    input  wire [WIDTH-1:0]      wdata,
    output wire                  wfull,
    output wire                  rempty,
    output wire [WIDTH-1:0]      rdata
);

    // Calculate address width from depth
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // for Gray code pointers with MSB wrap-around
    
    // Dual-port RAM instance wires
    wire wren;
    wire rden;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;
    wire [WIDTH-1:0] ram_rdata;

    // Binary pointers
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;

    // Gray-coded pointers
    reg [PTR_WIDTH-1:0] wptr;         // Write pointer Gray code
    reg [PTR_WIDTH-1:0] rptr;         // Read pointer Gray code

    // Synchronized pointers (write pointer synchronized to rclk domain, read pointer synchronized to wclk domain)
    reg [PTR_WIDTH-1:0] wptr_sync_rclk_0, wptr_sync_rclk_1;
    reg [PTR_WIDTH-1:0] rptr_sync_wclk_0, rptr_sync_wclk_1;

    // Binary pointers after synchronization
    wire [PTR_WIDTH-1:0] wptr_sync_rclk_bin;
    wire [PTR_WIDTH-1:0] rptr_sync_wclk_bin;

    // Write enable and read enable signals for RAM
    assign wren = winc & (~wfull);
    assign rden = rinc & (~rempty);

    // RAM write and read addresses are lower ADDR_WIDTH bits of binary pointers
    assign waddr = waddr_bin[ADDR_WIDTH-1:0];
    assign raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Data output from RAM
    assign rdata = ram_rdata;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wren),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rden),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Function: Binary to Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Function: Gray code to binary conversion
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i -1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    //-----------------------------------------
    // Write pointer logic - increments on wclk domain
    //-----------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= {PTR_WIDTH{1'b0}};
            wptr <= {PTR_WIDTH{1'b0}};
        end else begin
            if (wren) begin
                waddr_bin <= waddr_bin + 1'b1;
                wptr <= bin2gray(waddr_bin + 1'b1);
            end
        end
    end

    //-----------------------------------------
    // Read pointer logic - increments on rclk domain
    //-----------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= {PTR_WIDTH{1'b0}};
            rptr <= {PTR_WIDTH{1'b0}};
        end else begin
            if (rden) begin
                raddr_bin <= raddr_bin + 1'b1;
                rptr <= bin2gray(raddr_bin + 1'b1);
            end
        end
    end

    //-----------------------------------------
    // Synchronize read pointer (rptr) into wclk domain (for full detection)
    //-----------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_sync_wclk_0 <= {PTR_WIDTH{1'b0}};
            rptr_sync_wclk_1 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_sync_wclk_0 <= rptr;
            rptr_sync_wclk_1 <= rptr_sync_wclk_0;
        end
    end

    // Convert synchronized read pointer Gray to binary in wclk domain
    assign rptr_sync_wclk_bin = gray2bin(rptr_sync_wclk_1);

    //-----------------------------------------
    // Synchronize write pointer (wptr) into rclk domain (for empty detection)
    //-----------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_sync_rclk_0 <= {PTR_WIDTH{1'b0}};
            wptr_sync_rclk_1 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_sync_rclk_0 <= wptr;
            wptr_sync_rclk_1 <= wptr_sync_rclk_0;
        end
    end

    // Convert synchronized write pointer Gray to binary in rclk domain
    assign wptr_sync_rclk_bin = gray2bin(wptr_sync_rclk_1);

    //-----------------------------------------
    // Full flag generation - in wclk domain
    // FIFO is full when:
    // wptr[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_sync_wclk[PTR_WIDTH-1:PTR_WIDTH-2]
    // and lower bits equal
    //-----------------------------------------
    wire full_condition;
    assign full_condition =
        (wptr[PTR_WIDTH-1:PTR_WIDTH-2] == {~rptr_sync_wclk_1[PTR_WIDTH-1], ~rptr_sync_wclk_1[PTR_WIDTH-2]}) &&
        (wptr[PTR_WIDTH-3:0] == rptr_sync_wclk_1[PTR_WIDTH-3:0]);
    assign wfull = full_condition;

    //-----------------------------------------
    // Empty flag generation - in rclk domain
    // FIFO is empty when rptr == wptr_sync_rclk
    //-----------------------------------------
    assign rempty = (rptr == wptr_sync_rclk_1);

endmodule


// Dual-port RAM module as specified
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  wire                  wclk,
    input  wire                  wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,
    input  wire                  rclk,
    input  wire                  renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]       rdata
);

    // RAM memory
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port (synchronous write on wclk)
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port (synchronous read on rclk)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            // If no read enable, keep output stable or undefined - here hold previous data
            rdata <= rdata;
        end
    end

endmodule
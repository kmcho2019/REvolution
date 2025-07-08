`timescale 1ns/1ps
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input  [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM module
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc & ~wfull),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & ~rempty),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray coded pointers
    reg [PTR_WIDTH-1:0] wptr;
    reg [PTR_WIDTH-1:0] rptr;

    // Synchronized pointers
    reg [PTR_WIDTH-1:0] rptr_syn_wclk_0, rptr_syn_wclk_1;
    reg [PTR_WIDTH-1:0] wptr_syn_rclk_0, wptr_syn_rclk_1;

    // Binary pointers synchronized
    wire [PTR_WIDTH-1:0] rptr_syn_wclk;
    wire [PTR_WIDTH-1:0] wptr_syn_rclk;

    // Assign synchronized pointers after two-stage synchronizers
    assign rptr_syn_wclk = rptr_syn_wclk_1;
    assign wptr_syn_rclk = wptr_syn_rclk_1;

    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= {PTR_WIDTH{1'b0}};
            wptr <= {PTR_WIDTH{1'b0}};
        end else begin
            if (winc & ~wfull) begin
                wptr_bin <= wptr_bin + 1'b1;
            end
            // Gray code conversion
            wptr <= (wptr_bin >> 1) ^ wptr_bin;
        end
    end

    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= {PTR_WIDTH{1'b0}};
            rptr <= {PTR_WIDTH{1'b0}};
        end else begin
            if (rinc & ~rempty) begin
                rptr_bin <= rptr_bin + 1'b1;
            end
            // Gray code conversion
            rptr <= (rptr_bin >> 1) ^ rptr_bin;
        end
    end

    // Two-stage synchronizer for read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn_wclk_0 <= {PTR_WIDTH{1'b0}};
            rptr_syn_wclk_1 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_syn_wclk_0 <= rptr;
            rptr_syn_wclk_1 <= rptr_syn_wclk_0;
        end
    end

    // Two-stage synchronizer for write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn_rclk_0 <= {PTR_WIDTH{1'b0}};
            wptr_syn_rclk_1 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_syn_rclk_0 <= wptr;
            wptr_syn_rclk_1 <= wptr_syn_rclk_0;
        end
    end

    // Full condition:
    // FIFO is full when write pointer's Gray code equals read pointer Gray code with top two bits inverted and rest equal
    wire [PTR_WIDTH-1:0] rptr_syn_wclk_inv2msb;
    assign rptr_syn_wclk_inv2msb = {
        ~rptr_syn_wclk[PTR_WIDTH-1],
        ~rptr_syn_wclk[PTR_WIDTH-2],
        rptr_syn_wclk[PTR_WIDTH-3:0]
    };

    assign wfull = (wptr == rptr_syn_wclk_inv2msb);

    // Empty condition: read pointer equals synchronized write pointer
    assign rempty = (rptr == wptr_syn_rclk);

    // Address conversion: convert Gray-coded pointer to binary and use lower ADDR_WIDTH bits for RAM addresses
    // Gray to binary function
    function [PTR_WIDTH-1:0] gray_to_bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray_to_bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
            end
        end
    endfunction

    wire [PTR_WIDTH-1:0] wptr_bin_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_gray;

    assign wptr_bin_gray = gray_to_bin(wptr);
    assign rptr_bin_gray = gray_to_bin(rptr);

    // RAM address from lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr_bin = wptr_bin_gray[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_bin = rptr_bin_gray[ADDR_WIDTH-1:0];

endmodule


// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    // RAM memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            // If not reading, hold data (optional)
            rdata <= rdata;
        end
    end

endmodule
`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low write domain reset
    input                   rrstn,      // active low read domain reset
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output reg              wfull,
    output reg              rempty,
    output reg [WIDTH-1:0]  rdata
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ----- Binary write pointer -----
    reg [PTR_WIDTH-1:0] wptr_bin;
    // ----- Binary read pointer -----
    reg [PTR_WIDTH-1:0] rptr_bin;

    // ----- Gray-coded pointers for cross-domain sync -----
    wire [PTR_WIDTH-1:0] wptr_gray = binary_to_gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = binary_to_gray(rptr_bin);

    // ----- Synchronizers -----
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // ----- Convert synchronized Gray pointers back to binary -----
    wire [PTR_WIDTH-1:0] rptr_sync_bin_wclk = gray_to_binary(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] wptr_sync_bin_rclk = gray_to_binary(wptr_gray_rclk_sync);

    // ----- Write pointer update -----
    wire wfull_next;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wfull <= 1'b0;
        end else begin
            // Next full condition check
            wfull <= wfull_next;
            if (winc && !wfull) begin
                wptr_bin <= wptr_bin + 1'b1;
            end
        end
    end

    // ----- Read pointer update -----
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rempty <= 1'b1;
            rdata <= {WIDTH{1'b0}};
        end else begin
            rempty <= (rptr_gray == wptr_gray_rclk_sync);
            if (rinc && !rempty) begin
                rptr_bin <= rptr_bin + 1'b1;
            end
            // Read data registered from RAM below
        end
    end

    // ----- Full flag logic -----
    // Full when write pointer next equals read pointer synchronized to write domain,
    // with top two bits inverted and rest equal in Gray code
    wire [PTR_WIDTH-1:0] wptr_gray_next = binary_to_gray(wptr_bin + 1'b1);
    wire full_cond = 
        (wptr_gray_next[PTR_WIDTH-1]   == ~rptr_gray_wclk_sync[PTR_WIDTH-1]) &&
        (wptr_gray_next[PTR_WIDTH-2]   == ~rptr_gray_wclk_sync[PTR_WIDTH-2]) &&
        (wptr_gray_next[PTR_WIDTH-3:0] ==  rptr_gray_wclk_sync[PTR_WIDTH-3:0]);
    assign wfull_next = full_cond;

    // ----- RAM address: lower bits of binary pointers -----
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // ----- RAM enables -----
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // ----- RAM read data -----
    wire [WIDTH-1:0] ram_rdata;

    always @(posedge rclk) begin
        if (r_en)
            rdata <= ram_rdata;
    end

    // ----- Dual-port RAM instantiation -----
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

    // ----- Functions: binary to Gray and Gray to binary -----
    function [PTR_WIDTH-1:0] binary_to_gray;
        input [PTR_WIDTH-1:0] b;
        integer i;
        begin
            binary_to_gray[PTR_WIDTH-1] = b[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1) begin
                binary_to_gray[i] = b[i+1] ^ b[i];
            end
        end
    endfunction

    function [PTR_WIDTH-1:0] gray_to_binary;
        input [PTR_WIDTH-1:0] g;
        integer i;
        begin
            gray_to_binary[PTR_WIDTH-1] = g[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray_to_binary[i] = gray_to_binary[i+1] ^ g[i];
            end
        end
    endfunction

endmodule


// -------------------------
// Dual-port RAM with independent clocks and enables
// -------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                      rclk,
    input                      renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
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
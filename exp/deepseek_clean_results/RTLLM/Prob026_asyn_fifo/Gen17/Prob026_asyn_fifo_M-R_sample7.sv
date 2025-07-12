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

    // Parameter validation using generate
    generate
        if (DEPTH < 2) begin
            initial $error("DEPTH must be at least 2");
        end
        if (WIDTH < 1) begin
            initial $error("WIDTH must be at least 1");
        end
    endgenerate

    // Calculate required widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        return bin ^ (bin >> 1);
    endfunction

    // RAM interface signals
    wire wen = winc & ~wfull;
    wire ren = rinc & ~rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (wen ? 1 : 0);
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (ren ? 1 : 0);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Address assignments
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
        end
    end

    // Synchronizer modules
    sync_cell #(PTR_WIDTH) wptr_sync (
        .clk(rclk),
        .rstn(rrstn),
        .din(wptr_gray),
        .dout(wptr_gray_sync)
    );

    sync_cell #(PTR_WIDTH) rptr_sync (
        .clk(wclk),
        .rstn(wrstn),
        .din(rptr_gray),
        .dout(rptr_gray_sync)
    );

    // Full/empty detection
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);
    assign wfull = (wptr_gray_next == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                     rptr_gray_sync[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync);

endmodule

// Dual-port RAM module
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule

// Synchronizer cell
module sync_cell #(
    parameter WIDTH = 4
) (
    input clk,
    input rstn,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout
);

    reg [WIDTH-1:0] sync_reg;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_reg <= 0;
            dout <= 0;
        end else begin
            sync_reg <= din;
            dout <= sync_reg;
        end
    end

endmodule
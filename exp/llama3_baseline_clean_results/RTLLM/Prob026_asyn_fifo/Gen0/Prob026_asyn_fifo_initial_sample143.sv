module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)
(
    input  wclk,
    input  rstn,
    input  wrstn,
    input  rrstn,
    input  winc,
    input  rinc,
    input  [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;
    reg [PTR_WIDTH-1:0] waddr_bin_syn;
    reg [PTR_WIDTH-1:0] raddr_bin_syn;

    reg [PTR_WIDTH-1:0] wptr;
    reg [PTR_WIDTH-1:0] rptr;
    reg [PTR_WIDTH-1:0] wptr_syn;
    reg [PTR_WIDTH-1:0] rptr_syn;

    reg [WIDTH-1:0] ram_data[DEPTH];

    assign wfull = (wptr_syn == {~rptr_syn[PTR_WIDTH-1], rptr_syn[PTR_WIDTH-2:0]});
    assign rempty = (rptr_syn == wptr_syn);

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end
        else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr <= waddr_bin ^ (waddr_bin >> 1);
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end
        else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr <= raddr_bin ^ (raddr_bin >> 1);
        end
    end

    // Write Pointer Synchronizer
    reg [PTR_WIDTH-1:0] wptr_syn_tmp;
    always @(posedge rclk) begin
        wptr_syn_tmp <= wptr;
    end
    always @(posedge rclk) begin
        wptr_syn <= wptr_syn_tmp;
    end

    // Read Pointer Synchronizer
    reg [PTR_WIDTH-1:0] rptr_syn_tmp;
    always @(posedge wclk) begin
        rptr_syn_tmp <= rptr;
    end
    always @(posedge wclk) begin
        rptr_syn <= rptr_syn_tmp;
    end

    // Dual-Port RAM
    reg [WIDTH-1:0] ram_rdata;
    always @(posedge wclk) begin
        if (winc) begin
            ram_data[waddr_bin] <= wdata;
        end
    end

    always @(posedge rclk) begin
        ram_rdata <= ram_data[raddr_bin];
    end

    assign rdata = ram_rdata;

endmodule
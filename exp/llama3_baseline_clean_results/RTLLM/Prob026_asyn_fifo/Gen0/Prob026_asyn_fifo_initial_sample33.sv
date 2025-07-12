module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic           wclk,
    input  logic           rclk,
    input  logic           wrstn,
    input  logic           rrstn,
    input  logic           winc,
    input  logic           rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic           wfull,
    output logic           rempty,
    output logic [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    logic [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
    logic [ADDR_WIDTH-1:0] wptr, rptr, rptr_syn, wptr_syn;

    // Dual-port RAM
    dual_port_RAM #(
       .WIDTH(WIDTH),
       .DEPTH(DEPTH)
    ) dual_port_ram_inst (
       .wclk(wclk),
       .wenc(wrstn & winc),
       .waddr(waddr_bin),
       .wdata(wdata),
       .rclk(rclk),
       .renc(rrstn & rinc),
       .raddr(raddr_bin),
       .rdata(rdata)
    );

    // Write Pointer
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= '0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    assign wptr = {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1]^waddr_bin[ADDR_WIDTH-2], waddr_bin[ADDR_WIDTH-2]^waddr_bin[ADDR_WIDTH-3], waddr_bin[ADDR_WIDTH-3]};

    // Read Pointer
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= '0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    assign rptr = {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1]^raddr_bin[ADDR_WIDTH-2], raddr_bin[ADDR_WIDTH-2]^raddr_bin[ADDR_WIDTH-3], raddr_bin[ADDR_WIDTH-3]};

    // Write Pointer Synchronizer
    logic [ADDR_WIDTH-1:0] wptr_buff1, wptr_buff2;
    always @(posedge rclk) begin
        wptr_buff1 <= wptr;
        wptr_buff2 <= wptr_buff1;
    end
    assign wptr_syn = wptr_buff2;

    // Read Pointer Synchronizer
    logic [ADDR_WIDTH-1:0] rptr_buff1, rptr_buff2;
    always @(posedge wclk) begin
        rptr_buff1 <= rptr;
        rptr_buff2 <= rptr_buff1;
    end
    assign rptr_syn = rptr_buff2;

    // Full Signal
    logic [ADDR_WIDTH-1:0] wptr_full, rptr_full;
    assign wptr_full = ~rptr_syn[ADDR_WIDTH-1]? {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]} : rptr_syn;
    assign wfull = (wptr_syn == wptr_full);

    // Empty Signal
    assign rempty = (rptr_syn == wptr_syn);

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic           wclk,
    input  logic           wenc,
    input  logic [ADDR_WIDTH-1:0] waddr,
    input  logic [WIDTH-1:0] wdata,
    input  logic           rclk,
    input  logic           renc,
    input  logic [ADDR_WIDTH-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    logic [WIDTH-1:0] RAM_MEM [DEPTH];

    // Write Operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read Operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
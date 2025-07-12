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
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    // Dual-port RAM module
    wire wenc;
    wire renc;
    reg [WIDTH-1:0] rdata_reg;
    wire [$clog2(DEPTH)-1:0] waddr;
    wire [$clog2(DEPTH)-1:0] raddr;
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata_reg)
    );

    // Write and read pointers
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    // Gray code conversion
    reg [2:0] wptr;
    reg [2:0] rptr;
    reg [2:0] wptr_buff;
    reg [2:0] rptr_syn;

    // Full and empty signals
    assign wfull = (wptr == {~rptr_syn[2], rptr_syn[1:0]});
    assign rempty = (rptr == wptr);

    // Input and output connections
    assign wenc = winc;
    assign renc = rinc;
    assign waddr = waddr_bin;
    assign raddr = raddr_bin;
    assign rdata = rdata_reg;

    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_buff <= wptr;
            wptr <= {wptr[1:0], wptr[1]^wptr[0]};
        end
    end

    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr <= {rptr[1:0], rptr[1]^rptr[0]};
        end
    end

    // Read pointer synchronizer
    always @(posedge wclk) begin
        rptr_syn <= {rptr[1:0], rptr[1]^rptr[0]};
    end

endmodule

module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
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

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write logic
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read logic
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
module asyn_fifo (
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

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    reg [WIDTH-1:0] rdata_reg;
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [$clog2(DEPTH)-1:0] wptr_syn;
    reg [$clog2(DEPTH)-1:0] rptr_syn;
    reg wfull_reg;
    reg rempty_reg;

    // Dual-port RAM
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    assign wptr = {waddr_bin[$clog2(DEPTH)-1]^waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-2]^waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-3]};
    assign rptr = {raddr_bin[$clog2(DEPTH)-1]^raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-2]^raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-3]};

    // Write pointer synchronizer
    always @(posedge rclk) begin
        if (~rrstn) begin
            wptr_syn <= 0;
        end else begin
            wptr_syn <= wptr;
        end
    end

    // Read pointer synchronizer
    always @(posedge wclk) begin
        if (~wrstn) begin
            rptr_syn <= 0;
        end else begin
            rptr_syn <= rptr;
        end
    end

    // Full and empty signal generation
    assign wfull_reg = (wptr_syn[$clog2(DEPTH)-1] == ~rptr_syn[$clog2(DEPTH)-1]) && (wptr_syn[$clog2(DEPTH)-2:0] == rptr_syn[$clog2(DEPTH)-2:0]);
    assign rempty_reg = (wptr_syn == rptr_syn);

    // Dual-port RAM instantiation
    dual_port_RAM #(.WIDTH(WIDTH),.DEPTH(DEPTH)) u_dual_port_RAM (
       .wclk(wclk),
       .wenc(winc),
       .waddr(waddr_bin[$clog2(DEPTH)-1:0]),
       .wdata(wdata),
       .rclk(rclk),
       .renc(rinc),
       .raddr(raddr_bin[$clog2(DEPTH)-1:0]),
       .rdata(rdata_reg)
    );

    // Output assignments
    assign wfull = wfull_reg;
    assign rempty = rempty_reg;
    assign rdata = rdata_reg;

endmodule

module dual_port_RAM (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
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

module asyn_fifo (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    parameter DEPTH = 16;
    parameter WIDTH = 8;

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [WIDTH-1:0] RAM_rdata;
    reg [3:0] wptr, rptr;
    reg [3:0] wptr_syn, rptr_syn;
    reg [3:0] wptr_buff, rptr_buff;

    dual_port_RAM u_ram (
        .wclk(wclk),
        .wenc(winc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc),
        .raddr(raddr_bin),
        .rdata(RAM_rdata)
    );

    // Write pointer management
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Read pointer management
    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray code conversion for write pointer
    always @(posedge wclk) begin
        wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-2] ^ waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-3] ^ waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-4] ^ waddr_bin[$clog2(DEPTH)-3]};
    end

    // Gray code conversion for read pointer
    always @(posedge rclk) begin
        rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-2] ^ raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-3] ^ raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-4] ^ raddr_bin[$clog2(DEPTH)-3]};
    end

    // Two-stage trigger for read pointer synchronizer
    always @(posedge wclk) begin
        wptr_buff <= rptr;
    end
    always @(posedge wclk) begin
        rptr_syn <= wptr_buff;
    end

    // Two-stage trigger for write pointer synchronizer
    always @(posedge rclk) begin
        rptr_buff <= wptr;
    end
    always @(posedge rclk) begin
        wptr_syn <= rptr_buff;
    end

    // Full and empty detection
    always @(posedge wclk) begin
        if (wptr_syn == {~rptr[3], rptr[2:0]}) begin
            wfull <= 1'b1;
        end else begin
            wfull <= 1'b0;
        end
    end

    always @(posedge rclk) begin
        if (rptr == wptr_syn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= 1'b0;
        end
    end

    // Assign rdata
    always @(posedge rclk) begin
        rdata <= RAM_rdata;
    end

endmodule
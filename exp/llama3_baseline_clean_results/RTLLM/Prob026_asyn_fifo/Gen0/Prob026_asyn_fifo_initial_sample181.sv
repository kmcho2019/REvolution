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

    reg [WIDTH-1:0] ram_mem [DEPTH-1:0];

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    wire [WIDTH-1:0] rdata_ram;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_ram_inst (
        .wclk(wclk),
        .wenc(winc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc),
        .raddr(raddr_bin),
        .rdata(rdata_ram)
    );

    reg [WIDTH-1:0] rdata_buf;
    assign rdata = rdata_buf;

    always @(posedge rclk) begin
        if (!rrstn) begin
            rdata_buf <= 0;
        end else if (rinc) begin
            rdata_buf <= rdata_ram;
        end
    end

    reg [$clog2(DEPTH)-1:0] wptr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_bin;

    reg [2:0] wptr_gray;
    reg [2:0] rptr_gray;

    reg [2:0] wptr_gray_sync;
    reg [2:0] rptr_gray_sync;

    always @(posedge wclk) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= wptr_bin[2:0] ^ (wptr_bin[2:0] >> 1);
        end
    end

    always @(posedge rclk) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= rptr_bin[2:0] ^ (rptr_bin[2:0] >> 1);
        end
    end

    always @(posedge wclk) begin
        wptr_gray_sync <= wptr_gray;
    end

    always @(posedge rclk) begin
        rptr_gray_sync <= rptr_gray;
    end

    reg wfull_reg;
    reg rempty_reg;

    assign wfull = wfull_reg;
    assign rempty = rempty_reg;

    always @(posedge wclk) begin
        if (!wrstn) begin
            wfull_reg <= 0;
        end else if (wptr_gray_sync == ~rptr_gray_sync[2:1] ^ rptr_gray_sync[0]) begin
            wfull_reg <= 1;
        end else begin
            wfull_reg <= 0;
        end
    end

    always @(posedge rclk) begin
        if (!rrstn) begin
            rempty_reg <= 1;
        end else if (rptr_gray == wptr_gray_sync) begin
            rempty_reg <= 1;
        end else begin
            rempty_reg <= 0;
        end
    end

endmodule

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
    output [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] ram_mem [DEPTH-1:0];

    assign rdata = ram_mem[raddr];

    always @(posedge wclk) begin
        if (wenc) begin
            ram_mem[waddr] <= wdata;
        end
    end

endmodule
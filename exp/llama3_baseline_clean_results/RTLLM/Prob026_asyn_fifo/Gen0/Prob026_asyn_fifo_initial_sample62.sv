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

// Asynchronous FIFO module
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
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [WIDTH-1:0] rdata_reg;
    reg [$clog2(DEPTH)-1:0] wptr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_bin;
    reg [$clog2(DEPTH)-1:0] wptr_bin_syn;
    reg [$clog2(DEPTH)-1:0] rptr_bin_syn;
    reg [2:0] wptr_gray;
    reg [2:0] rptr_gray;
    reg [2:0] wptr_gray_syn;
    reg [2:0] rptr_gray_syn;
    wire wenc;
    wire renc;
    wire wfull_wire;
    wire rempty_wire;

    // Write pointer logic
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end
        else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Read pointer logic
    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end
        else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray code conversion
    assign wptr_gray[2:0] = {waddr_bin[2] ^ waddr_bin[1], waddr_bin[1] ^ waddr_bin[0], waddr_bin[0]};
    assign rptr_gray[2:0] = {raddr_bin[2] ^ raddr_bin[1], raddr_bin[1] ^ raddr_bin[0], raddr_bin[0]};

    // Pointer buffers
    reg [2:0] wptr_gray_syn_reg;
    reg [2:0] rptr_gray_syn_reg;
    always @(posedge wclk) begin
        wptr_gray_syn_reg <= wptr_gray;
    end
    always @(posedge rclk) begin
        rptr_gray_syn_reg <= rptr_gray;
    end
    assign wptr_gray_syn = wptr_gray_syn_reg;
    assign rptr_gray_syn = rptr_gray_syn_reg;

    // Full and empty signals
    assign wfull_wire = (wptr_gray_syn[2] != rptr_gray[2]) && (wptr_gray_syn[1:0] == rptr_gray[1:0]);
    assign rempty_wire = (wptr_gray_syn == rptr_gray);

    // Output assignments
    assign wfull = wfull_wire;
    assign rempty = rempty_wire;

    // Dual-port RAM instantiation
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr_bin),
        .rdata(rdata_reg)
    );

    // Write and read enable signals
    always @(posedge wclk) begin
        if (winc && ~wfull_wire) begin
            wenc <= 1'b1;
        end
        else begin
            wenc <= 1'b0;
        end
    end
    always @(posedge rclk) begin
        if (rinc && ~rempty_wire) begin
            renc <= 1'b1;
        end
        else begin
            renc <= 1'b0;
        end
    end

    // Output assignment
    assign rdata = rdata_reg;
endmodule
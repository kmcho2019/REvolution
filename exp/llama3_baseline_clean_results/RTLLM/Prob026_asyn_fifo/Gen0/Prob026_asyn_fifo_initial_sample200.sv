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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    // Dual-port RAM
    wire [WIDTH-1:0] rdata_int;
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_ram_instance (
        .wclk(wclk),
        .renc(rclk),
        .waddr(waddr_bin),
        .raddr(raddr_bin),
        .wenc(wen),
        .ren(ren),
        .wdata(wdata),
        .rdata(rdata_int)
    );

    // Write and read pointers
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    // Write pointer synchronizer
    reg [$clog2(DEPTH)-1:0] wptr_bin;
    reg [$clog2(DEPTH)-1:0] wptr_syn_bin;

    // Read pointer synchronizer
    reg [$clog2(DEPTH)-1:0] rptr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_syn_bin;

    // Gray code conversion
    wire [2:0] wptr_gray = wptr_bin[2:0] ^ {1'b0, wptr_bin[1:0]};
    wire [2:0] rptr_gray = rptr_bin[2:0] ^ {1'b0, rptr_bin[1:0]};

    // Full and empty detection
    assign wfull = (wptr_gray == {~rptr_gray[2], rptr_gray[1:0]});
    assign rempty = (rptr_gray == wptr_syn_bin[2:0] ^ {1'b0, wptr_syn_bin[1:0]});

    // Write and read enable signals
    reg wen;
    reg ren;

    // Write controller
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wen <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wen <= 1;
        end else begin
            wen <= 0;
        end
    end

    // Read controller
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            ren <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            ren <= 1;
        end else begin
            ren <= 0;
        end
    end

    // Write pointer synchronizer
    always @(posedge wclk) begin
        wptr_bin <= waddr_bin;
    end
    always @(posedge rclk) begin
        wptr_syn_bin <= wptr_bin;
    end

    // Read pointer synchronizer
    always @(posedge rclk) begin
        rptr_bin <= raddr_bin;
    end
    always @(posedge wclk) begin
        rptr_syn_bin <= rptr_bin;
    end

    // Output assignment
    assign rdata = rdata_int;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
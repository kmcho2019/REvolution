// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input  wire            wclk,
    input  wire            wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0] wdata,
    input  wire            rclk,
    input  wire            renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0] rdata
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
) (
    input  wire            wclk,
    input  wire            rclk,
    input  wire            wrstn,
    input  wire            rrstn,
    input  wire            winc,
    input  wire            rinc,
    input  wire [WIDTH-1:0] wdata,
    output wire            wfull,
    output wire            rempty,
    output reg  [WIDTH-1:0] rdata
);
    wire            wen, ren;
    wire [$clog2(DEPTH)-1:0] waddr, raddr;
    wire [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
    wire [2:0] wptr, rptr;
    wire [2:0] wptr_syn, rptr_syn;
    reg  [2:0] wptr_buff, rptr_buff;
    reg  [2:0] wptr_prev, rptr_prev;

    // Gray code conversion
    assign wptr = (waddr_bin[2:0] ^ {1'b0, waddr_bin[2:0][1:0]});
    assign rptr = (raddr_bin[2:0] ^ {1'b0, raddr_bin[2:0][1:0]});

    // Write pointer synchronizer
    always @(posedge rclk) begin
        if (~rrstn) begin
            wptr_syn <= 3'b000;
        end else begin
            wptr_syn <= wptr_buff;
        end
    end

    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_buff <= 3'b000;
        end else begin
            wptr_buff <= wptr;
        end
    end

    // Read pointer synchronizer
    always @(posedge wclk) begin
        if (~wrstn) begin
            rptr_syn <= 3'b000;
        end else begin
            rptr_syn <= rptr_buff;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_buff <= 3'b000;
        end else begin
            rptr_buff <= rptr;
        end
    end

    // Write data controller
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wen <= 1'b0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wen <= 1'b1;
        end else begin
            wen <= 1'b0;
        end
    end

    // Read data controller
    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            ren <= 1'b0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            ren <= 1'b1;
        end else begin
            ren <= 1'b0;
        end
    end

    // Full and empty signal generation
    assign wfull = (wptr_syn == {~rptr_syn[2], rptr_syn[1:0]});
    assign rempty = (rptr_syn == wptr_syn);

    // Dual-port RAM instantiation
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[2:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[2:0]),
        .rdata(rdata)
    );
endmodule
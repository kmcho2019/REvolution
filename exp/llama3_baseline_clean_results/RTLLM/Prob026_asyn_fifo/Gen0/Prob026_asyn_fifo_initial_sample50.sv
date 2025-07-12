// Dual-port RAM module
module dual_port_RAM(
    input         wclk,
    input         wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0] wdata,
    input         rclk,
    input         renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    integer i;

    always @(posedge wclk) begin
        if(wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if(renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            rdata <= 'z;
        end
    end
endmodule

// Asynchronous FIFO module
module asyn_fifo(
    input         wclk,
    input         wrstn,
    input         rclk,
    input         rrstn,
    input         winc,
    input         rinc,
    input  [WIDTH-1:0] wdata,
    output        wfull,
    output        rempty,
    output [WIDTH-1:0] rdata
);
    parameter DEPTH = 16;
    parameter WIDTH = 8;

    // Dual-port RAM instance
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) RAM_INSTANCE(
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[$clog2(DEPTH)-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[$clog2(DEPTH)-1:0]),
        .rdata(rdata)
    );

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [WIDTH-1:0] wen;
    reg [WIDTH-1:0] ren;
    reg [2:0] wptr;
    reg [2:0] rptr;
    reg [2:0] wptr_syn;
    reg [2:0] rptr_syn;
    reg [2:0] wptr_buff;
    reg [2:0] rptr_buff;

    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if(~wrstn) begin
            waddr_bin <= '0;
        end else if(winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if(~rrstn) begin
            raddr_bin <= '0;
        end else if(rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray code conversion for write pointer
    assign wptr = {waddr_bin[2] ^ waddr_bin[1], waddr_bin[1] ^ waddr_bin[0], waddr_bin[0]};

    // Gray code conversion for read pointer
    assign rptr = {raddr_bin[2] ^ raddr_bin[1], raddr_bin[1] ^ raddr_bin[0], raddr_bin[0]};

    // Two-stage trigger for write pointer synchronization
    always @(posedge rclk) begin
        wptr_buff <= wptr;
    end
    always @(posedge rclk) begin
        wptr_syn <= wptr_buff;
    end

    // Two-stage trigger for read pointer synchronization
    always @(posedge wclk) begin
        rptr_buff <= rptr;
    end
    always @(posedge wclk) begin
        rptr_syn <= rptr_buff;
    end

    // Write enable signal
    assign wen = (winc) ? 1'b1 : 1'b0;

    // Read enable signal
    assign ren = (rinc) ? 1'b1 : 1'b0;

    // Full signal
    assign wfull = (wptr_syn[2] == ~rptr[2]) && (wptr_syn[1:0] == rptr[1:0]);

    // Empty signal
    assign rempty = (rptr == wptr_syn);

endmodule
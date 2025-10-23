module asyn_fifo
#(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)
(
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

    // Dual-port RAM
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) RAM_inst
    (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write pointer
    reg [WIDTH-1:0] waddr_bin;
    reg [WIDTH-1:0] wptr;
    reg [WIDTH-1:0] wptr_buff;
    reg [WIDTH-1:0] wptr_buff2;

    // Read pointer
    reg [WIDTH-1:0] raddr_bin;
    reg [WIDTH-1:0] rptr;
    reg [WIDTH-1:0] rptr_syn;
    reg [WIDTH-1:0] rptr_syn2;

    // Write enable
    reg wen;

    // Read enable
    reg ren;

    // Write address
    reg [WIDTH-1:0] waddr;

    // Read address
    reg [WIDTH-1:0] raddr;

    // Initialize write and read pointers
    initial waddr_bin = 0;
    initial raddr_bin = 0;

    // Write pointer increment
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
            wptr_buff2 <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr <= waddr_bin ^ (waddr_bin >> 1);
            wptr_buff <= wptr;
            wptr_buff2 <= wptr_buff;
        end
    end

    // Read pointer increment
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_syn <= 0;
            rptr_syn2 <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr <= raddr_bin ^ (raddr_bin >> 1);
            rptr_syn <= rptr;
            rptr_syn2 <= rptr_syn;
        end
    end

    // Write address
    assign waddr = wptr[WIDTH-2:0];

    // Read address
    assign raddr = rptr_syn[WIDTH-2:0];

    // Write enable
    assign wen = winc;

    // Read enable
    assign ren = rinc;

    // Full signal
    assign wfull = (wptr_buff2 == {~rptr_syn2[WIDTH-1], rptr_syn2[WIDTH-2:0]});

    // Empty signal
    assign rempty = (rptr_syn == wptr_buff2);

endmodule

// Dual-port RAM module
module dual_port_RAM
#(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)
(
    input wclk,
    input wenc,
    input [WIDTH-2:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [WIDTH-2:0] raddr,
    output [WIDTH-1:0] rdata
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
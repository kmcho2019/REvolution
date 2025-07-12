module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Dual-port RAM instantiation
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [ADDR_WIDTH:0] waddr_bin;
    reg [ADDR_WIDTH:0] wptr;
    reg [ADDR_WIDTH:0] wptr_buff;
    wire [ADDR_WIDTH:0] wgray_next;
    wire [ADDR_WIDTH-1:0] waddr;
    wire wen;

    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin;
    reg [ADDR_WIDTH:0] rptr;
    reg [ADDR_WIDTH:0] rptr_buff;
    wire [ADDR_WIDTH:0] rgray_next;
    wire [ADDR_WIDTH-1:0] raddr;
    wire ren;

    // Synchronized pointers
    reg [ADDR_WIDTH:0] rptr_syn[1:0];
    reg [ADDR_WIDTH:0] wptr_syn[1:0];

    // Binary to Gray conversion
    assign wgray_next = waddr_bin ^ (waddr_bin >> 1);
    assign rgray_next = raddr_bin ^ (raddr_bin >> 1);

    // RAM address is lower bits of binary counter
    assign waddr = waddr_bin[ADDR_WIDTH-1:0];
    assign raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Write control
    assign wen = winc && !wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else begin
            if (wen) begin
                waddr_bin <= waddr_bin + 1;
                wptr <= wgray_next;
            end
            wptr_buff <= wptr;
        end
    end

    // Read control
    assign ren = rinc && !rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
        end else begin
            if (ren) begin
                raddr_bin <= raddr_bin + 1;
                rptr <= rgray_next;
            end
            rptr_buff <= rptr;
        end
    end

    // Write pointer synchronization to read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn[0] <= 0;
            wptr_syn[1] <= 0;
        end else begin
            wptr_syn[0] <= wptr_buff;
            wptr_syn[1] <= wptr_syn[0];
        end
    end

    // Read pointer synchronization to write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn[0] <= 0;
            rptr_syn[1] <= 0;
        end else begin
            rptr_syn[0] <= rptr_buff;
            rptr_syn[1] <= rptr_syn[0];
        end
    end

    // Full and empty generation
    assign wfull = (wptr == {~rptr_syn[1][ADDR_WIDTH:ADDR_WIDTH-1], 
                            rptr_syn[1][ADDR_WIDTH-2:0]});
    assign rempty = (rptr == wptr_syn[1]);

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

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
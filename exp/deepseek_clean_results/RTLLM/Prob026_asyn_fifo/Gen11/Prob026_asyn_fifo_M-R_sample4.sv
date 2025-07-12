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
    output wire wfull,
    output wire rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // RAM control signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Pointer registers (binary)
    reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;
    
    // Next pointer values
    wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + wen;
    wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + ren;

    // Gray code conversions
    wire [ADDR_WIDTH:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [ADDR_WIDTH:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    wire [ADDR_WIDTH:0] wptr_gray_next = wptr_bin_next ^ (wptr_bin_next >> 1);
    wire [ADDR_WIDTH:0] rptr_gray_next = rptr_bin_next ^ (rptr_bin_next >> 1);

    // Pointer synchronization registers
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
        end
    end

    // Write pointer synchronization (to read domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync2, wptr_sync1} <= 0;
        end else begin
            {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
        end
    end

    // Read pointer synchronization (to write domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync2, rptr_sync1} <= 0;
        end else begin
            {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
        end
    end

    // Full/empty detection
    assign wfull = (wptr_gray_next == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                      rptr_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync2);

    // RAM address assignment (drop MSB)
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

endmodule

module dual_port_ram #(
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];

endmodule
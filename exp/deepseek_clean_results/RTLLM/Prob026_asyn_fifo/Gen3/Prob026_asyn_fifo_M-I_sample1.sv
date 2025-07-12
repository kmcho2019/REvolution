module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 2  // Configurable synchronizer depth
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
    output [WIDTH-1:0] rdata
);

    // Parameter validation
    initial begin
        if (DEPTH < 2 || (DEPTH & (DEPTH-1)) != 0)
            $error("FIFO depth must be power of 2 and >= 2");
        if (WIDTH < 1) $error("FIFO width must be >= 1");
        if (SYNC_STAGES < 2) $error("Sync stages must be >= 2");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Binary to Gray code conversion
    function automatic [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // RAM interface signals
    wire wenc;
    wire [ADDR_WIDTH-1:0] waddr;
    wire renc;
    wire [ADDR_WIDTH-1:0] raddr;

    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [ADDR_WIDTH:0] wptr_bin = 0;
    reg [ADDR_WIDTH:0] wptr_gray = 0;
    wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + (wenc);
    wire [ADDR_WIDTH:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin = 0;
    reg [ADDR_WIDTH:0] rptr_gray = 0;
    wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + (renc);
    wire [ADDR_WIDTH:0] rptr_gray_next = bin2gray(rptr_bin_next);

    // Synchronizer chains
    reg [ADDR_WIDTH:0] sync_rptr_gray [0:SYNC_STAGES-1];
    reg [ADDR_WIDTH:0] sync_wptr_gray [0:SYNC_STAGES-1];

    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Pointer synchronization
    integer i;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (i = 0; i < SYNC_STAGES; i = i+1)
                sync_rptr_gray[i] <= 0;
        end else begin
            sync_rptr_gray[0] <= rptr_gray;
            for (i = 1; i < SYNC_STAGES; i = i+1)
                sync_rptr_gray[i] <= sync_rptr_gray[i-1];
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (i = 0; i < SYNC_STAGES; i = i+1)
                sync_wptr_gray[i] <= 0;
        end else begin
            sync_wptr_gray[0] <= wptr_gray;
            for (i = 1; i < SYNC_STAGES; i = i+1)
                sync_wptr_gray[i] <= sync_wptr_gray[i-1];
        end
    end

    // Address generation
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Control signals
    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;

    // Full/empty detection
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= (wptr_gray_next == {~sync_rptr_gray[SYNC_STAGES-1][ADDR_WIDTH:ADDR_WIDTH-1], 
                      sync_rptr_gray[SYNC_STAGES-1][ADDR_WIDTH-2:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rptr_gray == sync_wptr_gray[SYNC_STAGES-1]);
        end
    end

endmodule

module dual_port_ram #(
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule
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

    // Parameter validation
    initial begin
        if (DEPTH < 2) $error("FIFO depth must be at least 2");
        if (WIDTH < 1) $error("FIFO width must be at least 1");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Binary to Gray code conversion function
    function automatic [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Gray code to binary conversion function (for simulation debug)
    function automatic [ADDR_WIDTH:0] gray2bin;
        input [ADDR_WIDTH:0] gray;
        integer i;
        begin
            gray2bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
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
    wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + (winc && !wfull);
    wire [ADDR_WIDTH:0] wptr_gray = bin2gray(wptr_bin);
    wire [ADDR_WIDTH:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin = 0;
    wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + (rinc && !rempty);
    wire [ADDR_WIDTH:0] rptr_gray = bin2gray(rptr_bin);
    wire [ADDR_WIDTH:0] rptr_gray_next = bin2gray(rptr_bin_next);

    // Synchronizer chains
    reg [ADDR_WIDTH:0] sync_rptr_gray[0:1];
    reg [ADDR_WIDTH:0] sync_wptr_gray[0:1];

    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
        end
    end

    // Generate synchronizer flip-flops
    genvar i;
    generate
        // Read pointer synchronization to write domain
        for (i = 0; i < 2; i = i+1) begin : sync_rptr
            always @(posedge wclk or negedge wrstn) begin
                if (!wrstn) begin
                    sync_rptr_gray[i] <= 0;
                end else begin
                    if (i == 0)
                        sync_rptr_gray[i] <= rptr_gray;
                    else
                        sync_rptr_gray[i] <= sync_rptr_gray[i-1];
                end
            end
        end

        // Write pointer synchronization to read domain
        for (i = 0; i < 2; i = i+1) begin : sync_wptr
            always @(posedge rclk or negedge rrstn) begin
                if (!rrstn) begin
                    sync_wptr_gray[i] <= 0;
                end else begin
                    if (i == 0)
                        sync_wptr_gray[i] <= wptr_gray;
                    else
                        sync_wptr_gray[i] <= sync_wptr_gray[i-1];
                end
            end
        end
    endgenerate

    // Address generation
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Control signals
    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;

    // Full detection: Gray code comparison with MSB inversion
    wire [ADDR_WIDTH:0] wfull_test = {~sync_rptr_gray[1][ADDR_WIDTH:ADDR_WIDTH-1], 
                                     sync_rptr_gray[1][ADDR_WIDTH-2:0]};
    assign wfull = (wptr_gray_next == wfull_test);

    // Empty detection
    assign rempty = (rptr_gray == sync_wptr_gray[1]);

endmodule

// Dual-port RAM module with same interface
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
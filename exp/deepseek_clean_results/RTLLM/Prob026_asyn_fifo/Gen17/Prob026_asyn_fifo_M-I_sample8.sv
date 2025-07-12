module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ALMOST_FULL = DEPTH-2,
    parameter ALMOST_EMPTY = 1,
    parameter OUTPUT_REG = 1
) (
    input wclk,
    input rclk,
    input wrst_n,
    input rrst_n,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata,
    output wire almost_full,
    output wire almost_empty
);

    initial begin
        if ((DEPTH & (DEPTH-1)) != 0)
            $error("DEPTH must be power of 2");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Gray code functions
    function automatic [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        return bin ^ (bin >> 1);
    endfunction

    function automatic [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write domain signals
    reg [PTR_WIDTH-1:0] waddr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync [0:2];
    wire [PTR_WIDTH-1:0] rptr_gray_sync = rptr_sync[2];
    wire wen = winc && !wfull;

    // Read domain signals
    reg [PTR_WIDTH-1:0] raddr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync [0:2];
    wire [PTR_WIDTH-1:0] wptr_gray_sync = wptr_sync[2];
    wire ren = rinc && !rempty;

    // Dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .OUTPUT_REG(OUTPUT_REG)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // Write pointer logic
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            waddr_bin <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            waddr_bin <= waddr_bin + 1;
            wptr_gray <= bin2gray(waddr_bin + 1);
        end
    end

    // Read pointer logic
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            raddr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            raddr_bin <= raddr_bin + 1;
            rptr_gray <= bin2gray(raddr_bin + 1);
        end
    end

    // Write domain synchronizer (3-stage)
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rptr_sync[2] <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
            rptr_sync[2] <= rptr_sync[1];
        end
    end

    // Read domain synchronizer (3-stage)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wptr_sync[2] <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
            wptr_sync[2] <= wptr_sync[1];
        end
    end

    // Status flags
    wire [PTR_WIDTH-1:0] waddr_gray_next = bin2gray(waddr_bin + 1);
    wire [PTR_WIDTH-1:0] raddr_gray_next = bin2gray(raddr_bin + 1);

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wfull <= 0;
        end else begin
            wfull <= (waddr_gray_next == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2],
                                         rptr_gray_sync[PTR_WIDTH-3:0]});
        end
    end

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rempty <= 1;
        end else begin
            rempty <= (rptr_gray == wptr_gray_sync);
        end
    end

    // Almost full/empty indicators
    assign almost_full = (gray2bin(wptr_gray) - gray2bin(rptr_gray_sync) >= ALMOST_FULL;
    assign almost_empty = (gray2bin(wptr_gray_sync) - gray2bin(rptr_gray) <= ALMOST_EMPTY;

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter OUTPUT_REG = 1
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
    reg [WIDTH-1:0] rdata_int;

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
            // Write-through bypass
            if (renc && (waddr == raddr))
                rdata_int <= wdata;
        end
    end

    // Read port with optional output register
    generate if (OUTPUT_REG) begin
        always @(posedge rclk) begin
            if (renc) rdata_int <= mem[raddr];
            rdata <= rdata_int;
        end
    end else begin
        always @(posedge rclk) begin
            if (renc) rdata <= mem[raddr];
        end
    end endgenerate

endmodule
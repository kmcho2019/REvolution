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
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Gray to binary conversion
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // RAM signals
    wire [ADDR_WIDTH-1:0] waddr = gray2bin(wptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = gray2bin(rptr_gray)[ADDR_WIDTH-1:0];
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // RAM instantiation
    dp_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wen(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .ren(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (wen && !wfull);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (ren && !rempty);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // Pointer synchronization
    reg [PTR_WIDTH-1:0] rptr_sync0, rptr_sync1;
    reg [PTR_WIDTH-1:0] wptr_sync0, wptr_sync1;

    // Write clock domain synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync1, rptr_sync0} <= 0;
        else {rptr_sync1, rptr_sync0} <= {rptr_sync0, rptr_gray};
    end

    // Read clock domain synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync1, wptr_sync0} <= 0;
        else {wptr_sync1, wptr_sync0} <= {wptr_sync0, wptr_gray};
    end

    // Full condition
    wire [PTR_WIDTH-1:0] rptr_bin_sync = gray2bin(rptr_sync1);
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 0;
        else wfull <= ((wptr_bin_next[ADDR_WIDTH] != rptr_bin_sync[ADDR_WIDTH]) &&
                       (wptr_bin_next[ADDR_WIDTH-1:0] == rptr_bin_sync[ADDR_WIDTH-1:0]));
    end

    // Empty condition
    wire [PTR_WIDTH-1:0] wptr_bin_sync = gray2bin(wptr_sync1);
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1;
        else rempty <= (rptr_bin_next == wptr_bin_sync);
    end

endmodule

module dp_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wen,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input ren,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    always @(posedge rclk) if (ren) rdata <= mem[raddr];

endmodule
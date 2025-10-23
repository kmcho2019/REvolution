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

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Instantiate RAM module
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

    // Write domain
    reg [ADDR_WIDTH:0] wptr_bin = 0;
    reg [ADDR_WIDTH:0] wptr_gray = 0;
    reg [ADDR_WIDTH:0] rptr_sync1 = 0, rptr_sync2 = 0;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin >> 1) ^ wptr_bin; // Binary to Gray conversion
        end
    end

    // Read domain
    reg [ADDR_WIDTH:0] rptr_bin = 0;
    reg [ADDR_WIDTH:0] rptr_gray = 0;
    reg [ADDR_WIDTH:0] wptr_sync1 = 0, wptr_sync2 = 0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin >> 1) ^ rptr_bin; // Binary to Gray conversion
        end
    end

    // Synchronizers
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync2, rptr_sync1} <= 0;
        end else begin
            {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync2, wptr_sync1} <= 0;
        end else begin
            {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
        end
    end

    // Gray to binary conversion for addresses
    function [ADDR_WIDTH-1:0] gray2bin;
        input [ADDR_WIDTH:0] gray;
        reg [ADDR_WIDTH:0] bin;
        integer i;
        begin
            bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i-1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin[ADDR_WIDTH-1:0];
        end
    endfunction

    assign waddr = gray2bin(wptr_gray);
    assign raddr = gray2bin(rptr_gray);

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                 rptr_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync2);

endmodule
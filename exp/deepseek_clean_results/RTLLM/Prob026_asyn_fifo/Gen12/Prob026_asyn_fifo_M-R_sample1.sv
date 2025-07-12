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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];

endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 2
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
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Gray code conversion functions
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction

    function [PTR_WIDTH-1:0] gray_inc;
        input [PTR_WIDTH-1:0] gray;
        gray_inc = bin2gray(gray2bin(gray) + 1);
    endfunction

    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_next);

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1;
    wire [PTR_WIDTH-1:0] rptr_gray_next = bin2gray(rptr_next);

    // Synchronization chains
    wire [PTR_WIDTH-1:0] rptr_gray_sync;
    wire [PTR_WIDTH-1:0] wptr_gray_sync;

    generate
        if (SYNC_STAGES == 1) begin
            reg [PTR_WIDTH-1:0] rptr_sync_reg;
            reg [PTR_WIDTH-1:0] wptr_sync_reg;

            always @(posedge wclk or negedge wrstn)
                if (!wrstn) rptr_sync_reg <= 0;
                else rptr_sync_reg <= rptr_gray;

            always @(posedge rclk or negedge rrstn)
                if (!rrstn) wptr_sync_reg <= 0;
                else wptr_sync_reg <= wptr_gray;

            assign rptr_gray_sync = rptr_sync_reg;
            assign wptr_gray_sync = wptr_sync_reg;
        end
        else begin
            reg [PTR_WIDTH-1:0] rptr_sync_chain [0:SYNC_STAGES-1];
            reg [PTR_WIDTH-1:0] wptr_sync_chain [0:SYNC_STAGES-1];
            integer i;

            always @(posedge wclk or negedge wrstn) begin
                if (!wrstn) begin
                    for (i = 0; i < SYNC_STAGES; i = i+1)
                        rptr_sync_chain[i] <= 0;
                end
                else begin
                    rptr_sync_chain[0] <= rptr_gray;
                    for (i = 1; i < SYNC_STAGES; i = i+1)
                        rptr_sync_chain[i] <= rptr_sync_chain[i-1];
                end
            end

            always @(posedge rclk or negedge rrstn) begin
                if (!rrstn) begin
                    for (i = 0; i < SYNC_STAGES; i = i+1)
                        wptr_sync_chain[i] <= 0;
                end
                else begin
                    wptr_sync_chain[0] <= wptr_gray;
                    for (i = 1; i < SYNC_STAGES; i = i+1)
                        wptr_sync_chain[i] <= wptr_sync_chain[i-1];
                end
            end

            assign rptr_gray_sync = rptr_sync_chain[SYNC_STAGES-1];
            assign wptr_gray_sync = wptr_sync_chain[SYNC_STAGES-1];
        end
    endgenerate

    // Control signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Pointer updates
    always @(posedge wclk or negedge wrstn)
        if (!wrstn) wptr_bin <= 0;
        else if (wen) wptr_bin <= wptr_next;

    always @(posedge rclk or negedge rrstn)
        if (!rrstn) rptr_bin <= 0;
        else if (ren) rptr_bin <= rptr_next;

    // Status flags
    assign wfull = (wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_gray_sync[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync);

    // RAM instance
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

endmodule
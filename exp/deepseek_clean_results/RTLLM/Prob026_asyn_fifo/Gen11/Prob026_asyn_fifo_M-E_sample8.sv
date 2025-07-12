module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 3  // Configurable synchronizer depth
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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    localparam SAFE_ZONE = 2;  // Minimum difference between pointers

    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Gray to Binary conversion (for mirror pointers)
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        reg [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + (winc & !wfull);
    reg [PTR_WIDTH-1:0] rptr_mirror;

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + (rinc & !rempty);
    reg [PTR_WIDTH-1:0] wptr_mirror;

    // Synchronizer chains
    reg [PTR_WIDTH-1:0] w2r_sync [0:SYNC_STAGES-1];
    reg [PTR_WIDTH-1:0] r2w_sync [0:SYNC_STAGES-1];

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            rptr_mirror <= 0;
        end else begin
            if (winc && !wfull) wptr_bin <= wptr_next;
            rptr_mirror <= gray2bin(w2r_sync[SYNC_STAGES-1]);
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            wptr_mirror <= 0;
        end else begin
            if (rinc && !rempty) rptr_bin <= rptr_next;
            wptr_mirror <= gray2bin(r2w_sync[SYNC_STAGES-1]);
        end
    end

    // Write to read synchronizer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (int i=0; i<SYNC_STAGES; i++) w2r_sync[i] <= 0;
        end else begin
            w2r_sync[0] <= wptr_gray;
            for (int i=1; i<SYNC_STAGES; i++)
                w2r_sync[i] <= w2r_sync[i-1];
        end
    end

    // Read to write synchronizer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (int i=0; i<SYNC_STAGES; i++) r2w_sync[i] <= 0;
        end else begin
            r2w_sync[0] <= rptr_gray;
            for (int i=1; i<SYNC_STAGES; i++)
                r2w_sync[i] <= r2w_sync[i-1];
        end
    end

    // Predictive flag generation
    wire [PTR_WIDTH-1:0] wptr_pred = wptr_bin + (winc & !wfull);
    wire [PTR_WIDTH-1:0] rptr_pred = rptr_bin + (rinc & !rempty);
    
    assign wfull = ((wptr_pred - rptr_mirror) >= (DEPTH - SAFE_ZONE));
    assign rempty = ((wptr_mirror - rptr_pred) <= SAFE_ZONE);

    // RAM instance with byte-wise write enable
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram (
        .wclk(wclk),
        .wenc({WIDTH{winc & !wfull}}),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & !rempty),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input [WIDTH-1:0] wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Byte-wise write
    always @(posedge wclk) begin
        for (int i=0; i<WIDTH; i++)
            if (wenc[i]) mem[waddr][i] <= wdata[i];
    end
    
    always @(posedge rclk) if (renc) rdata <= mem[raddr];
endmodule
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

    // Validate DEPTH is power of 2 and > 1
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0 || DEPTH < 2)
            $error("DEPTH must be power of 2 and greater than 1");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM implementation
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] rdata_reg;
    assign rdata = rdata_reg;

    // Gray code conversion functions
    function automatic [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction

    function automatic [PTR_WIDTH-1:0] gray2bin;
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
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_next);

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1;
    wire [PTR_WIDTH-1:0] rptr_gray_next = bin2gray(rptr_next);

    // Synchronization registers (2-stage)
    reg [PTR_WIDTH-1:0] rptr_sync = 0;
    reg [PTR_WIDTH-1:0] wptr_sync = 0;

    // Control signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_sync <= 0;
        end else begin
            // Pointer synchronization
            rptr_sync <= bin2gray(gray2bin(rptr_gray));
            
            // Write operation
            if (wen) begin
                mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
                wptr_bin <= wptr_next;
                wptr_gray <= wptr_gray_next;
            end
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            wptr_sync <= 0;
        end else begin
            // Pointer synchronization
            wptr_sync <= bin2gray(gray2bin(wptr_gray));
            
            // Read operation
            if (ren) begin
                rdata_reg <= mem[rptr_bin[ADDR_WIDTH-1:0]];
                rptr_bin <= rptr_next;
                rptr_gray <= rptr_gray_next;
            end
        end
    end

    // Status flags (combinational)
    always @(*) begin
        // Full when Gray codes match except MSB and second MSB
        wfull = (wptr_gray == {~rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                              rptr_sync[PTR_WIDTH-3:0]});
        
        // Empty when Gray codes match exactly
        rempty = (rptr_gray == wptr_sync);
    end

endmodule
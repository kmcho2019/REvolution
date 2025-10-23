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

    // Validate DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $display("Error: DEPTH must be power of 2 (given %0d)", DEPTH);
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // Extra bit for full/empty detection

    // Dual-port RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

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

    // ========== Write Domain ==========
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;

    // Binary to Gray code conversion
    always @(*) begin
        wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    end

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            // Pointer synchronization
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
            
            // Pointer increment
            if (wen) begin
                wptr_bin <= wptr_bin + 1;
            end
        end
    end

    // ========== Read Domain ==========
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;

    // Binary to Gray code conversion
    always @(*) begin
        rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            // Pointer synchronization
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
            
            // Pointer increment
            if (ren) begin
                rptr_bin <= rptr_bin + 1;
            end
        end
    end

    // ========== Full/Empty Detection ==========
    // Full detection (write domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= ((wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                     rptr_gray_sync2[PTR_WIDTH-3:0]}) && (wptr_bin != rptr_gray_sync2));
        end
    end

    // Empty detection (read domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rptr_gray == wptr_gray_sync2);
        end
    end

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

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
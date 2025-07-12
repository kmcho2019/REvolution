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

    // Check if DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Dual-port RAM instance
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

    // Write domain logic
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
            wfull <= 0;
        end else begin
            // Update write pointer
            if (wen) wptr_bin <= wptr_bin + 1;
            
            // Synchronize read pointer
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
            
            // Full detection: Gray codes differ only in MSB and next bit
            wfull <= (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                     rptr_sync2[PTR_WIDTH-3:0]});
        end
    end

    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    // Read domain logic
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
            rempty <= 1;
        end else begin
            // Update read pointer
            if (ren) rptr_bin <= rptr_bin + 1;
            
            // Synchronize write pointer
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
            
            // Empty detection: pointers match exactly
            rempty <= (rptr_gray == wptr_sync2);
        end
    end

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

    // Write operation
    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter BYTE_WRITE = (WIDTH % 8 == 0) ? 1 : 0
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

    // Parameter validation using generate
    generate
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            initial begin
                $error("DEPTH must be power of 2");
                $finish;
            end
        end
    endgenerate

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr_gray[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_gray[ADDR_WIDTH-1:0];

    // Dual-port RAM instance
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .BYTE_WRITE(BYTE_WRITE)
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

    // Write domain
    reg [PTR_WIDTH-1:0] wptr, wptr_next;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    
    // Read pointer synchronization (3-stage for better MTBF)
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2, rptr_sync3;
    wire [PTR_WIDTH-1:0] rptr_sync_gray = rptr_sync3;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            {rptr_sync3, rptr_sync2, rptr_sync1} <= 0;
        end else begin
            wptr <= wen ? wptr + 1 : wptr;
            {rptr_sync3, rptr_sync2, rptr_sync1} <= {rptr_sync2, rptr_sync1, rptr_gray};
        end
    end

    // Read domain
    reg [PTR_WIDTH-1:0] rptr, rptr_next;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    
    // Write pointer synchronization (3-stage)
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2, wptr_sync3;
    wire [PTR_WIDTH-1:0] wptr_sync_gray = wptr_sync3;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            {wptr_sync3, wptr_sync2, wptr_sync1} <= 0;
        end else begin
            rptr <= ren ? rptr + 1 : rptr;
            {wptr_sync3, wptr_sync2, wptr_sync1} <= {wptr_sync2, wptr_sync1, wptr_gray};
        end
    end

    // Full/empty detection
    wire full_next = (wptr_gray == {~rptr_sync_gray[PTR_WIDTH-1:PTR_WIDTH-2], 
                                    rptr_sync_gray[PTR_WIDTH-3:0]});
    wire empty_next = (rptr_gray == wptr_sync_gray);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 1'b0;
        else wfull <= full_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1'b1;
        else rempty <= empty_next;
    end

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter BYTE_WRITE = 0
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

    generate
        if (BYTE_WRITE && WIDTH >= 8) begin
            // Byte-wide write enable implementation
            always @(posedge wclk) begin
                for (integer i=0; i<WIDTH/8; i=i+1) begin
                    if (wenc) begin
                        mem[waddr][i*8 +: 8] <= wdata[i*8 +: 8];
                    end
                end
            end
        end else begin
            // Standard implementation
            always @(posedge wclk) begin
                if (wenc) mem[waddr] <= wdata;
            end
        end
    endgenerate

    // Output register for better timing
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (renc) rdata_reg <= mem[raddr];
    end
    
    assign rdata = rdata_reg;

endmodule
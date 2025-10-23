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

    // Validate parameters
    if (DEPTH < 2) begin
        $error("FIFO depth must be at least 2");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Dual-port RAM instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc & !wfull),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & !rempty),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
    
    // Write domain signals
    reg [ADDR_WIDTH:0] wptr_bin, wptr_gray;
    wire [ADDR_WIDTH:0] wptr_next = wptr_bin + (winc & !wfull);
    wire [ADDR_WIDTH:0] wptr_gray_next = wptr_next ^ (wptr_next >> 1);
    
    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin, rptr_gray;
    wire [ADDR_WIDTH:0] rptr_next = rptr_bin + (rinc & !rempty);
    wire [ADDR_WIDTH:0] rptr_gray_next = rptr_next ^ (rptr_next >> 1);
    
    // Synchronizers (2-stage for metastability protection)
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_next;
            wptr_gray <= wptr_gray_next;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_next;
            rptr_gray <= rptr_gray_next;
        end
    end
    
    // Write pointer synchronization to read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= wptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end
    
    // Read pointer synchronization to write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= rptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end
    
    // Full and empty detection (combinational)
    assign wfull = (wptr_gray == {~wptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                wptr_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == rptr_sync2);

endmodule

// Dual-port RAM module remains the same
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
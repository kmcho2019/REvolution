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

    // Check if DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Binary pointers
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    
    // Gray code pointers
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    
    // Synchronized pointers (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end
    
    // Status flags
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync2);
    
    // Memory control
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    
    // Pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_bin + 1'b1;
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_bin + 1'b1;
        end
    end
    
    // Dual-port RAM instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

endmodule

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
    
    // Initialize RAM to zeros (optional)
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end
    
    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end
    
    // Read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
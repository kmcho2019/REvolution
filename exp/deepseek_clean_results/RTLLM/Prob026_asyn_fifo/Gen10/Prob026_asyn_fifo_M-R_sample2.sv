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

    // Parameter validation
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Binary pointers (registered)
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    
    // Gray code conversion (combinational)
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    
    // Synchronized pointers (2-stage FF)
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;
    
    // Cross-clock domain synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_gray_sync2, wptr_gray_sync1} <= 0;
        else        {wptr_gray_sync2, wptr_gray_sync1} <= {wptr_gray_sync1, wptr_gray};
    end
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_gray_sync2, rptr_gray_sync1} <= 0;
        else        {rptr_gray_sync2, rptr_gray_sync1} <= {rptr_gray_sync1, rptr_gray};
    end
    
    // Status flags (combinational)
    assign wfull = (wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_gray_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync2);
    
    // Pointer updates (combinational control, sequential storage)
    wire wptr_inc = winc && !wfull;
    wire rptr_inc = rinc && !rempty;
    
    assign wptr_bin = (!wrstn) ? 0 : 
                     (wptr_inc) ? wptr_bin + 1'b1 : wptr_bin;
    
    assign rptr_bin = (!rrstn) ? 0 : 
                     (rptr_inc) ? rptr_bin + 1'b1 : rptr_bin;
    
    // Memory control
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    
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

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write port
    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end
    
    // Read port
    always @(posedge rclk) begin
        rdata <= renc ? mem[raddr] : {WIDTH{1'b0}};
    end

endmodule
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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory interface
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    
    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1'b1;
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1'b1;
    
    // Synchronization registers
    reg [PTR_WIDTH-1:0] rptr_sync [0:1];
    reg [PTR_WIDTH-1:0] wptr_sync [0:1];
    
    // Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_next;
            wptr_gray <= bin2gray(wptr_next);
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_next;
            rptr_gray <= bin2gray(rptr_next);
        end
    end
    
    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
        end
    end
    
    // Full/empty detection
    always @(*) begin
        // Full when Gray codes match except MSB
        wfull = (wptr_gray == {~rptr_sync[1][PTR_WIDTH-1:PTR_WIDTH-2], 
                              rptr_sync[1][PTR_WIDTH-3:0]});
        // Empty when Gray codes exactly match
        rempty = (rptr_gray == wptr_sync[1]);
    end

endmodule

// Dual-port RAM module
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
    
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule
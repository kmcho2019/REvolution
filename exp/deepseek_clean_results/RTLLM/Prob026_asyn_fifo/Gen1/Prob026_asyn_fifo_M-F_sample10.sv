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
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Explicit wire declarations
    wire wenc;
    wire [ADDR_WIDTH-1:0] waddr;
    wire renc;
    wire [ADDR_WIDTH-1:0] raddr;
    
    // Dual-port RAM instantiation
    dual_port_RAM #(
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

    // Write domain signals
    reg [ADDR_WIDTH:0] waddr_bin;
    reg [ADDR_WIDTH:0] wptr;
    wire [ADDR_WIDTH:0] wgray_next;
    wire wfull_next;
    
    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin;
    reg [ADDR_WIDTH:0] rptr;
    wire [ADDR_WIDTH:0] rgray_next;
    wire rempty_next;
    
    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;

    // Binary to Gray conversion
    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else if (winc && !wfull) begin
            waddr_bin <= waddr_bin + 1;
            wptr <= wgray_next;
        end
    end

    assign wgray_next = bin2gray(waddr_bin + 1);
    assign waddr = waddr_bin[ADDR_WIDTH-1:0];
    assign wenc = winc && !wfull;

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else if (rinc && !rempty) begin
            raddr_bin <= raddr_bin + 1;
            rptr <= rgray_next;
        end
    end

    assign rgray_next = bin2gray(raddr_bin + 1);
    assign raddr = raddr_bin[ADDR_WIDTH-1:0];
    assign renc = rinc && !rempty;

    // Synchronize read pointer to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Synchronize write pointer to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Full and empty generation
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= (wgray_next == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                    rptr_sync2[ADDR_WIDTH-2:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rgray_next == wptr_sync2);
        end
    end

endmodule

module dual_port_RAM #(
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

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
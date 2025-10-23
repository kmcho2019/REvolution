module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    // Write interface
    input wire wclk,
    input wire wrstn,
    input wire winc,
    input wire [WIDTH-1:0] wdata,
    output wire wfull,
    
    // Read interface
    input wire rclk,
    input wire rrstn,
    input wire rinc,
    output wire [WIDTH-1:0] rdata,
    output wire rempty
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Dual-port RAM
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
    reg [ADDR_WIDTH:0] wptr_bin = 0;
    reg [ADDR_WIDTH:0] wptr_gray = 0;
    wire [ADDR_WIDTH:0] wptr_gray_next;
    wire [ADDR_WIDTH:0] wptr_bin_next;
    wire wenc;
    wire [ADDR_WIDTH-1:0] waddr;
    
    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin = 0;
    reg [ADDR_WIDTH:0] rptr_gray = 0;
    wire [ADDR_WIDTH:0] rptr_gray_next;
    wire [ADDR_WIDTH:0] rptr_bin_next;
    wire renc;
    wire [ADDR_WIDTH-1:0] raddr;
    
    // Synchronized pointers
    reg [ADDR_WIDTH:0] rptr_gray_sync1 = 0;
    reg [ADDR_WIDTH:0] rptr_gray_sync2 = 0;
    reg [ADDR_WIDTH:0] wptr_gray_sync1 = 0;
    reg [ADDR_WIDTH:0] wptr_gray_sync2 = 0;
    
    // Binary to Gray conversion
    assign wptr_gray_next = wptr_bin_next ^ (wptr_bin_next >> 1);
    assign rptr_gray_next = rptr_bin_next ^ (rptr_bin_next >> 1);
    
    // Gray to binary conversion
    function [ADDR_WIDTH:0] gray2bin;
        input [ADDR_WIDTH:0] gray;
        integer i;
        begin
            gray2bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction
    
    // Write pointer control
    assign wptr_bin_next = wptr_bin + (winc & ~wfull);
    assign wenc = winc & ~wfull;
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    
    // Read pointer control
    assign rptr_bin_next = rptr_bin + (rinc & ~rempty);
    assign renc = rinc & ~rempty;
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];
    
    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                 rptr_gray_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_gray_sync2);
    
    // Write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
            
            // Synchronize read pointer to write clock domain
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end
    
    // Read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
            
            // Synchronize write pointer to read clock domain
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire wclk,
    input wire wenc,
    input wire [$clog2(DEPTH)-1:0] waddr,
    input wire [WIDTH-1:0] wdata,
    input wire rclk,
    input wire renc,
    input wire [$clog2(DEPTH)-1:0] raddr,
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
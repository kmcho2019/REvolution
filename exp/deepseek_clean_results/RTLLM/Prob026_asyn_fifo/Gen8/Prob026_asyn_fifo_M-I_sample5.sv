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

    // Check if DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    
    // Memory control
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    
    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Gray to binary conversion
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
        for (int i = PTR_WIDTH-2; i >= 0; i--)
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
    endfunction
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
        end
    end
    
    // Write domain synchronization (read pointer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end
    
    // Read domain synchronization (write pointer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end
    
    // Status flags generation
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            wfull <= ((wptr_gray[PTR_WIDTH-1] != rptr_sync2[PTR_WIDTH-1]) &&
                     (wptr_gray[PTR_WIDTH-2] != rptr_sync2[PTR_WIDTH-2]) &&
                     (wptr_gray[PTR_WIDTH-3:0] == rptr_sync2[PTR_WIDTH-3:0]));
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            rempty <= (rptr_gray == wptr_sync2);
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

    (* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end
    
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // RAM interface signals
    wire [ADDR_WIDTH-1:0] waddr = wptr_gray[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_gray[ADDR_WIDTH-1:0];
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    
    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );
    
    // Pointer declarations
    reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;
    wire [ADDR_WIDTH:0] wptr_gray, rptr_gray;
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;
    
    // Binary to Gray conversion functions
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    function [ADDR_WIDTH:0] gray2bin(input [ADDR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction
    
    // Write pointer logic (binary)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
        end
    end
    
    // Read pointer logic (binary)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
        end
    end
    
    // Gray code conversion
    assign wptr_gray = bin2gray(wptr_bin);
    assign rptr_gray = bin2gray(rptr_bin);
    
    // Pointer synchronization (write to read domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync1, wptr_sync2} <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end
    
    // Pointer synchronization (read to write domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync1, rptr_sync2} <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end
    
    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                  rptr_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync2);

endmodule

// Dual-port RAM module
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
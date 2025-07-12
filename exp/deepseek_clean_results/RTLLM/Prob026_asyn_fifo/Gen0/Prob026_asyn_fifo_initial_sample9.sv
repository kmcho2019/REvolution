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
    
    // Dual-port RAM instantiation
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
    
    // Write domain signals
    reg [ADDR_WIDTH:0] waddr_bin, waddr_bin_next;
    reg [ADDR_WIDTH:0] wptr, wptr_next;
    wire wen;
    
    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin, raddr_bin_next;
    reg [ADDR_WIDTH:0] rptr, rptr_next;
    wire ren;
    
    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_syn1, rptr_syn2;
    reg [ADDR_WIDTH:0] wptr_syn1, wptr_syn2;
    
    // Binary to Gray conversion
    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction
    
    // Gray to binary conversion (not used in this implementation)
    function [ADDR_WIDTH:0] gray2bin;
        input [ADDR_WIDTH:0] gray;
        reg [ADDR_WIDTH:0] bin;
        integer i;
        begin
            bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i-1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction
    
    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else begin
            waddr_bin <= waddr_bin_next;
            wptr <= wptr_next;
        end
    end
    
    always @(*) begin
        waddr_bin_next = waddr_bin;
        wptr_next = wptr;
        
        if (winc && !wfull) begin
            waddr_bin_next = waddr_bin + 1;
            wptr_next = bin2gray(waddr_bin_next);
        end
    end
    
    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            raddr_bin <= raddr_bin_next;
            rptr <= rptr_next;
        end
    end
    
    always @(*) begin
        raddr_bin_next = raddr_bin;
        rptr_next = rptr;
        
        if (rinc && !rempty) begin
            raddr_bin_next = raddr_bin + 1;
            rptr_next = bin2gray(raddr_bin_next);
        end
    end
    
    // Write pointer synchronizer (to read domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn1 <= 0;
            wptr_syn2 <= 0;
        end else begin
            wptr_syn1 <= wptr;
            wptr_syn2 <= wptr_syn1;
        end
    end
    
    // Read pointer synchronizer (to write domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn1 <= 0;
            rptr_syn2 <= 0;
        end else begin
            rptr_syn1 <= rptr;
            rptr_syn2 <= rptr_syn1;
        end
    end
    
    // Full and empty generation
    assign wfull = (wptr == {~rptr_syn2[ADDR_WIDTH:ADDR_WIDTH-1], 
                            rptr_syn2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr == wptr_syn2);
    
    // RAM control signals
    assign wen = winc && !wfull;
    assign ren = rinc && !rempty;

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
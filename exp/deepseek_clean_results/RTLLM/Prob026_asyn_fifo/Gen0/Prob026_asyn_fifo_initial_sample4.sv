module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk, rclk,
    input wrstn, rrstn,
    input winc, rinc,
    input [WIDTH-1:0] wdata,
    output wfull, rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

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
    reg [ADDR_WIDTH:0] waddr_bin = 0;
    reg [ADDR_WIDTH:0] wptr = 0;
    reg [ADDR_WIDTH:0] wptr_buff = 0;
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];
    wire wenc = winc && !wfull;

    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin = 0;
    reg [ADDR_WIDTH:0] rptr = 0;
    reg [ADDR_WIDTH:0] rptr_buff = 0;
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];
    wire renc = rinc && !rempty;

    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_syn[1:0];
    reg [ADDR_WIDTH:0] wptr_syn[1:0];

    // Binary to Gray conversion
    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    // Gray to Binary conversion
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
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else begin
            if (wenc) begin
                waddr_bin <= waddr_bin + 1;
            end
            wptr <= bin2gray(waddr_bin);
            wptr_buff <= wptr;
        end
    end

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
        end else begin
            if (renc) begin
                raddr_bin <= raddr_bin + 1;
            end
            rptr <= bin2gray(raddr_bin);
            rptr_buff <= rptr;
        end
    end

    // Read pointer synchronizer (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn[0] <= 0;
            rptr_syn[1] <= 0;
        end else begin
            rptr_syn[0] <= rptr;
            rptr_syn[1] <= rptr_syn[0];
        end
    end

    // Write pointer synchronizer (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn[0] <= 0;
            wptr_syn[1] <= 0;
        end else begin
            wptr_syn[0] <= wptr;
            wptr_syn[1] <= wptr_syn[0];
        end
    end

    // Full and empty generation
    assign wfull = (wptr == {~rptr_syn[1][ADDR_WIDTH:ADDR_WIDTH-1], 
                            rptr_syn[1][ADDR_WIDTH-2:0]});
    assign rempty = (rptr == wptr_syn[1]);

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk, rclk,
    input wenc, renc,
    input [$clog2(DEPTH)-1:0] waddr, raddr,
    input [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
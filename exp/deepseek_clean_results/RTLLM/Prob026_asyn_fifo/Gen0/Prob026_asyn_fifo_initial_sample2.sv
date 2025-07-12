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
    wire [ADDR_WIDTH:0] wgray_next;
    wire wfull_next;
    wire wenc = winc && !wfull;
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];

    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin = 0;
    reg [ADDR_WIDTH:0] rptr = 0;
    wire [ADDR_WIDTH:0] rgray_next;
    wire rempty_next;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_syn1 = 0, rptr_syn2 = 0;
    reg [ADDR_WIDTH:0] wptr_syn1 = 0, wptr_syn2 = 0;

    // Binary to Gray conversion
    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    // Gray to Binary conversion (not used in this implementation)
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
        end else begin
            if (wenc) begin
                waddr_bin <= waddr_bin + 1;
            end
            wptr <= wgray_next;
        end
    end

    assign wgray_next = bin2gray(waddr_bin + (wenc ? 1 : 0));

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            if (renc) begin
                raddr_bin <= raddr_bin + 1;
            end
            rptr <= rgray_next;
        end
    end

    assign rgray_next = bin2gray(raddr_bin + (renc ? 1 : 0));

    // Synchronize read pointer to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn1 <= 0;
            rptr_syn2 <= 0;
        end else begin
            rptr_syn1 <= rptr;
            rptr_syn2 <= rptr_syn1;
        end
    end

    // Synchronize write pointer to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn1 <= 0;
            wptr_syn2 <= 0;
        end else begin
            wptr_syn1 <= wptr;
            wptr_syn2 <= wptr_syn1;
        end
    end

    // Full and empty generation
    assign wfull_next = (wgray_next == {~rptr_syn2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                      rptr_syn2[ADDR_WIDTH-2:0]});
    assign rempty_next = (rgray_next == wptr_syn2);

    // Output registers
    reg wfull_reg = 0;
    reg rempty_reg = 1;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull_reg <= 0;
        end else begin
            wfull_reg <= wfull_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty_reg <= 1;
        end else begin
            rempty_reg <= rempty_next;
        end
    end

    assign wfull = wfull_reg;
    assign rempty = rempty_reg;

endmodule

// Dual-port RAM module
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
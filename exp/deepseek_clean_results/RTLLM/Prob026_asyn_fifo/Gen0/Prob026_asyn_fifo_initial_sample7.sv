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
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [ADDR_WIDTH:0] waddr_bin;
    reg [ADDR_WIDTH:0] wptr;
    wire [ADDR_WIDTH:0] wgray_next;
    wire wfull_next;
    wire wen = winc && !wfull;

    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin;
    reg [ADDR_WIDTH:0] rptr;
    wire [ADDR_WIDTH:0] rgray_next;
    wire rempty_next;
    wire ren = rinc && !rempty;

    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_syn0, rptr_syn1;
    reg [ADDR_WIDTH:0] wptr_syn0, wptr_syn1;

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
        end else begin
            if (wen) begin
                waddr_bin <= waddr_bin + 1;
            end
            wptr <= wgray_next;
        end
    end

    assign wgray_next = bin2gray(waddr_bin + (wen ? 1 : 0));
    assign waddr = waddr_bin[ADDR_WIDTH-1:0];

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            if (ren) begin
                raddr_bin <= raddr_bin + 1;
            end
            rptr <= rgray_next;
        end
    end

    assign rgray_next = bin2gray(raddr_bin + (ren ? 1 : 0));
    assign raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Write pointer synchronization to read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn0 <= 0;
            wptr_syn1 <= 0;
        end else begin
            wptr_syn0 <= wptr;
            wptr_syn1 <= wptr_syn0;
        end
    end

    // Read pointer synchronization to write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn0 <= 0;
            rptr_syn1 <= 0;
        end else begin
            rptr_syn0 <= rptr;
            rptr_syn1 <= rptr_syn0;
        end
    end

    // Full and empty generation
    assign wfull_next = (wgray_next == {~rptr_syn1[ADDR_WIDTH:ADDR_WIDTH-1], 
                                      rptr_syn1[ADDR_WIDTH-2:0]});
    assign rempty_next = (rgray_next == wptr_syn1);

    reg wfull_reg, rempty_reg;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull_reg <= 1'b0;
        end else begin
            wfull_reg <= wfull_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty_reg <= 1'b1;
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
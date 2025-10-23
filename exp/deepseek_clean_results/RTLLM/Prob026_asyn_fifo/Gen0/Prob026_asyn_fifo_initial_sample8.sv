module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk, rclk,
    input wrstn, rrstn,
    input winc, rinc,
    input [WIDTH-1:0] wdata,
    output wfull, rempty,
    output [WIDTH-1:0] rdata
);

    // Calculate address width
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
    wire wenc;
    wire [ADDR_WIDTH-1:0] waddr;

    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin = 0;
    reg [ADDR_WIDTH:0] rptr = 0;
    wire [ADDR_WIDTH:0] rgray_next;
    wire renc;
    wire [ADDR_WIDTH-1:0] raddr;

    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_syn0 = 0, rptr_syn1 = 0;
    reg [ADDR_WIDTH:0] wptr_syn0 = 0, wptr_syn1 = 0;

    // Binary to Gray conversion
    assign wgray_next = waddr_bin ^ (waddr_bin >> 1);
    assign rgray_next = raddr_bin ^ (raddr_bin >> 1);

    // RAM address connections (use lower bits)
    assign waddr = waddr_bin[ADDR_WIDTH-1:0];
    assign raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Write control logic
    assign wenc = winc && !wfull;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else begin
            if (wenc) begin
                waddr_bin <= waddr_bin + 1;
                wptr <= wgray_next;
            end
        end
    end

    // Read control logic
    assign renc = rinc && !rempty;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            if (renc) begin
                raddr_bin <= raddr_bin + 1;
                rptr <= rgray_next;
            end
        end
    end

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
    assign rempty = (rptr == wptr_syn1);
    assign wfull = (wgray_next == {~rptr_syn1[ADDR_WIDTH:ADDR_WIDTH-1], 
                                  rptr_syn1[ADDR_WIDTH-2:0]});

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk, rclk,
    input wenc, renc,
    input [$clog2(DEPTH)-1:0] waddr, raddr,
    input [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata
);

    // Memory array
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
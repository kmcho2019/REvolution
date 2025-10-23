module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire         wclk,    // Write clock
    input  wire         rclk,    // Read clock
    input  wire         wrstn,   // Write reset (active low)
    input  wire         rrstn,   // Read reset (active low)
    input  wire         winc,    // Write increment
    input  wire         rinc,    // Read increment
    input  wire [WIDTH-1:0] wdata, // Write data
    output wire         wfull,   // FIFO full
    output wire         rempty,  // FIFO empty
    output wire [WIDTH-1:0] rdata  // Read data
);

    // Dual-Port RAM module
    wire [WIDTH-1:0] ram_rdata;
    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_inst (
        .wclk(wclk), .wenc(winc), .waddr(waddr_bin[$clog2(DEPTH)-1:0]), .wdata(wdata),
        .rclk(rclk), .renc(rinc), .raddr(raddr_bin[$clog2(DEPTH)-1:0]), .rdata(ram_rdata)
    );

    // Regs for write and read pointers in binary
    reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;

    // Gray code conversion for write and read pointers
    reg [$clog2(DEPTH)-1:0] wptr, rptr, wptr_syn, rptr_syn;

    // Buffer registers for write and read pointers
    reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;

    // Full and empty detection
    assign wfull = (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
    assign rempty = (rptr_syn == wptr);

    // Read data output
    assign rdata = (rempty) ? {WIDTH{1'b0}} : ram_rdata;

    // Pointer increment logic
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr_buff <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_buff <= wptr;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr_buff <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr_buff <= rptr;
        end
    end

    // Gray code conversion and synchronization
    always @(posedge wclk) begin
        wptr <= waddr_bin ^ (waddr_bin >> 1);
    end

    always @(posedge rclk) begin
        rptr <= raddr_bin ^ (raddr_bin >> 1);
    end

    // Two-stage synchronizer for write pointer
    reg [$clog2(DEPTH)-1:0] wptr_sync1, wptr_sync2;
    always @(posedge rclk) begin
        wptr_sync1 <= wptr;
        wptr_sync2 <= wptr_sync1;
    end
    assign wptr_syn = wptr_sync2;

    // Two-stage synchronizer for read pointer
    reg [$clog2(DEPTH)-1:0] rptr_sync1, rptr_sync2;
    always @(posedge wclk) begin
        rptr_sync1 <= rptr;
        rptr_sync2 <= rptr_sync1;
    end
    assign rptr_syn = rptr_sync2;

endmodule

// Dual-Port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire         wclk,    // Write clock
    input  wire         wenc,    // Write enable
    input  wire [$clog2(DEPTH)-1:0] waddr, // Write address
    input  wire [WIDTH-1:0] wdata, // Write data
    input  wire         rclk,    // Read clock
    input  wire         renc,    // Read enable
    input  wire [$clog2(DEPTH)-1:0] raddr, // Read address
    output wire [WIDTH-1:0] rdata  // Read data
);

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    assign rdata = (renc) ? RAM_MEM[raddr] : {WIDTH{1'b0}};

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

endmodule
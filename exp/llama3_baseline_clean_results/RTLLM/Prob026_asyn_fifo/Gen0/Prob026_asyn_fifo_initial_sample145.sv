module asyn_fifo (
    input               wclk,        // Write clock signal
    input               rclk,        // Read clock signal
    input               wrstn,       // Write reset signal
    input               rrstn,       // Read reset signal
    input               winc,        // Write increment signal
    input               rinc,        // Read increment signal
    input   [WIDTH-1:0]  wdata,       // Write data input
    output              wfull,       // Write full signal
    output              rempty,      // Read empty signal
    output  [WIDTH-1:0]  rdata       // Read data output
);

    parameter DEPTH = 16;
    parameter WIDTH = 8;

    // Dual-port RAM module
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata_ram)
    );

    // Write pointer
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [WIDTH-1:0] wptr_buff, wptr, wptr_syn;

    // Read pointer
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [WIDTH-1:0] rptr_buff, rptr, rptr_syn;

    // Write enable and read enable signals
    reg wen, ren;

    // Write and read data
    reg [WIDTH-1:0] rdata_ram;

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr_buff <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_buff <= wptr_buff + 1;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr_buff <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr_buff <= rptr_buff + 1;
        end
    end

    // Gray code conversion for write pointer
    always @(posedge wclk) begin
        wptr <= {wptr_buff[$clog2(DEPTH)-1] ^ wptr_buff[$clog2(DEPTH)-2], wptr_buff[$clog2(DEPTH)-2:0]};
    end

    // Gray code conversion for read pointer
    always @(posedge rclk) begin
        rptr <= {rptr_buff[$clog2(DEPTH)-1] ^ rptr_buff[$clog2(DEPTH)-2], rptr_buff[$clog2(DEPTH)-2:0]};
    end

    // Two-stage trigger for write pointer
    always @(posedge wclk) begin
        wptr_syn <= wptr;
    end

    // Two-stage trigger for read pointer
    always @(posedge rclk) begin
        rptr_syn <= rptr;
    end

    // Write enable signal
    assign wen = winc;

    // Read enable signal
    assign ren = rinc;

    // Write address
    assign waddr = waddr_bin;

    // Read address
    assign raddr = raddr_bin;

    // Read data output
    assign rdata = rdata_ram;

    // Full signal
    assign wfull = (wptr_syn[$clog2(DEPTH)-1] != rptr_syn[$clog2(DEPTH)-1]) && (wptr_syn[$clog2(DEPTH)-2:0] == rptr_syn[$clog2(DEPTH)-2:0]);

    // Empty signal
    assign rempty = (wptr_syn == rptr_syn);

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input               wclk,        // Write clock signal
    input               wenc,        // Write enable signal
    input   [$clog2(DEPTH)-1:0] waddr, // Write address
    input   [WIDTH-1:0]  wdata,      // Write data input
    input               rclk,        // Read clock signal
    input               renc,        // Read enable signal
    input   [$clog2(DEPTH)-1:0] raddr, // Read address
    output  [WIDTH-1:0]  rdata       // Read data output
);

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

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
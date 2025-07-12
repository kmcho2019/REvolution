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
    output reg [WIDTH-1:0] rdata
);

    // Dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) RAM (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[($clog2(DEPTH)-1):0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[($clog2(DEPTH)-1):0]),
        .rdata(rdata_ram)
    );

    // Write and Read Pointers
    reg [($clog2(DEPTH)-1):0] waddr_bin;
    reg [($clog2(DEPTH)-1):0] raddr_bin;
    reg [($clog2(DEPTH)-1):0] wptr_gray;
    reg [($clog2(DEPTH)-1):0] rptr_gray;
    reg [($clog2(DEPTH)-1):0] wptr_buff;
    reg [($clog2(DEPTH)-1):0] rptr_buff;

    // Write Pointer
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Read Pointer
    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray Code Conversion
    always @(*) begin
        wptr_gray = waddr_bin ^ (waddr_bin >> 1);
        rptr_gray = raddr_bin ^ (raddr_bin >> 1);
    end

    // Pointer Buffers
    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr_gray;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr_gray;
        end
    end

    // Full and Empty Signals
    reg wfull_int;
    reg rempty_int;

    always @(*) begin
        wfull_int = (wptr_buff[$clog2(DEPTH)-1] != rptr_buff[$clog2(DEPTH)-1]) && (wptr_buff[($clog2(DEPTH)-2):0] == rptr_buff[($clog2(DEPTH)-2):0]);
        rempty_int = (rptr_buff == wptr_buff);
    end

    // Output Assignments
    always @(*) begin
        wfull = wfull_int;
        rempty = rempty_int;
        rdata = rdata_ram;
    end

    // Write and Read Enable Signals
    reg wen;
    reg ren;

    always @(*) begin
        wen = winc;
        ren = rinc;
    end

endmodule

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

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write Operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read Operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            rdata <= 0;
        end
    end

endmodule
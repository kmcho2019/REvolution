// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  logic        wclk,
    input  logic        wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0] wdata,
    input  logic        rclk,
    input  logic        renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);

    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always_ff @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always_ff @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule

// Asynchronous FIFO module
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic        wclk,
    input  logic        rclk,
    input  logic        wrstn,
    input  logic        rrstn,
    input  logic        winc,
    input  logic        rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic        wfull,
    output logic        rempty,
    output logic [WIDTH-1:0] rdata
);

    logic        wen, ren;
    logic [$clog2(DEPTH)-1:0] waddr, raddr;
    logic [WIDTH-1:0] rdata_reg;
    logic        wfull_reg, rempty_reg;
    logic [1:0] wptr_bin, rptr_bin;
    logic [1:0] wptr_gray, rptr_gray;
    logic [1:0] wptr_syn, rptr_syn;
    logic [1:0] wptr_buff, rptr_buff;
    logic [1:0] rptr_buff_syn;

    // Dual-port RAM instantiation
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) RAM_INST (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata_reg)
    );

    // Write pointer binary and Gray code conversion
    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end else if (winc) begin
            wptr_bin <= (wptr_bin + 1) % DEPTH;
        end
    end

    assign wptr_gray = wptr_bin ^ (wptr_bin >> 1);

    // Read pointer binary and Gray code conversion
    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= (rptr_bin + 1) % DEPTH;
        end
    end

    assign rptr_gray = rptr_bin ^ (rptr_bin >> 1);

    // Write pointer synchronizer
    always_ff @(posedge wclk) begin
        wptr_buff <= wptr_gray;
    end

    always_ff @(posedge rclk) begin
        wptr_syn <= wptr_buff;
    end

    // Read pointer synchronizer
    always_ff @(posedge rclk) begin
        rptr_buff <= rptr_gray;
    end

    always_ff @(posedge wclk) begin
        rptr_syn <= rptr_buff;
    end

    // Empty and full conditions
    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            wfull_reg <= 0;
        end else if ((wptr_gray[1:0] == ~rptr_syn[1:0]) && (wptr_gray[0] == rptr_syn[0])) begin
            wfull_reg <= 1;
        end else begin
            wfull_reg <= 0;
        end
    end

    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            rempty_reg <= 0;
        end else if (rptr_gray == wptr_syn) begin
            rempty_reg <= 1;
        end else begin
            rempty_reg <= 0;
        end
    end

    // Control signals
    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            wen <= 0;
        end else if (winc && ~wfull_reg) begin
            wen <= 1;
        end else begin
            wen <= 0;
        end
    end

    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            ren <= 0;
        end else if (rinc && ~rempty_reg) begin
            ren <= 1;
        end else begin
            ren <= 0;
        end
    end

    // Address generation
    assign waddr = wptr_bin[$clog2(DEPTH)-1:0];
    assign raddr = rptr_bin[$clog2(DEPTH)-1:0];

    // Output assignments
    assign wfull = wfull_reg;
    assign rempty = rempty_reg;
    assign rdata = rdata_reg;

endmodule
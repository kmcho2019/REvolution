module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,     // Write clock signal
    input  logic             rclk,     // Read clock signal
    input  logic             wrstn,    // Write reset signal (active low)
    input  logic             rrstn,    // Read reset signal (active low)
    input  logic             winc,     // Write increment signal
    input  logic             rinc,     // Read increment signal
    input  logic [WIDTH-1:0] wdata,    // Write data input
    output logic             wfull,    // Write full signal
    output logic             rempty,   // Read empty signal
    output logic [WIDTH-1:0] rdata     // Read data output
);

    // Dual-port RAM module
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[3:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[3:0]),
        .rdata(rdata)
    );

    // Write pointer
    logic [3:0] waddr_bin;
    logic [3:0] wptr;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Gray code conversion for write pointer
    assign wptr = {waddr_bin[3] ^ waddr_bin[2], waddr_bin[2] ^ waddr_bin[1], waddr_bin[1] ^ waddr_bin[0], waddr_bin[0]};

    // Write pointer synchronizer
    logic [3:0] wptr_syn;
    logic [3:0] wptr_buff;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
        end
    end
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_syn <= 0;
        end else begin
            wptr_syn <= wptr_buff;
        end
    end

    // Read pointer
    logic [3:0] raddr_bin;
    logic [3:0] rptr;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray code conversion for read pointer
    assign rptr = {raddr_bin[3] ^ raddr_bin[2], raddr_bin[2] ^ raddr_bin[1], raddr_bin[1] ^ raddr_bin[0], raddr_bin[0]};

    // Read pointer synchronizer
    logic [3:0] rptr_syn;
    logic [3:0] rptr_buff;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr;
        end
    end
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_syn <= 0;
        end else begin
            rptr_syn <= rptr_buff;
        end
    end

    // Write enable signal
    logic wen;
    assign wen = winc;

    // Read enable signal
    logic ren;
    assign ren = rinc;

    // Full condition
    assign wfull = (wptr_syn == {~rptr_syn[3], rptr_syn[2:0]});

    // Empty condition
    assign rempty = (rptr == wptr_syn);

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,     // Write clock signal
    input  logic             wenc,     // Write enable signal
    input  logic [3:0]       waddr,    // Write address
    input  logic [WIDTH-1:0] wdata,    // Write data
    input  logic             rclk,     // Read clock signal
    input  logic             renc,     // Read enable signal
    input  logic [3:0]       raddr,    // Read address
    output logic [WIDTH-1:0] rdata     // Read data
);

    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

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
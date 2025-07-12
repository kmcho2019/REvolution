module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic           wclk,     // Write clock
    input  logic           rclk,     // Read clock
    input  logic           wrstn,    // Write reset
    input  logic           rrstn,    // Read reset
    input  logic           winc,     // Write increment
    input  logic           rinc,     // Read increment
    input  logic [WIDTH-1:0] wdata,   // Write data
    output logic           wfull,    // Write full
    output logic           rempty,   // Read empty
    output logic [WIDTH-1:0] rdata    // Read data
);

    // Define dual-port RAM module
    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
        .wclk(wclk), 
        .wenc(wen), 
        .waddr(waddr_bin), 
        .wdata(wdata), 
        .rclk(rclk), 
        .renc(ren), 
        .raddr(raddr_bin), 
        .rdata(rdata)
    );

    // Define write pointer
    logic [WIDTH-1:0] waddr_bin;
    logic [WIDTH-1:0] wptr;
    logic [WIDTH-1:0] wptr_buff;
    logic [WIDTH-1:0] wptr_syn;

    // Define read pointer
    logic [WIDTH-1:0] raddr_bin;
    logic [WIDTH-1:0] rptr;
    logic [WIDTH-1:0] rptr_buff;
    logic [WIDTH-1:0] rptr_syn;

    // Define write and read enables
    logic wen, ren;

    // Define Gray code conversion
    logic [2:0] wgray;
    logic [2:0] rgray;

    // Define full and empty signals
    logic full, empty;

    // Define counters for write and read pointers
    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Define Gray code conversion
    always_comb begin
        wgray = {waddr_bin[2], waddr_bin[2] ^ waddr_bin[1], waddr_bin[1] ^ waddr_bin[0]};
        rgray = {raddr_bin[2], raddr_bin[2] ^ raddr_bin[1], raddr_bin[1] ^ raddr_bin[0]};
    end

    // Define two-stage trigger for write pointer
    always_ff @(posedge wclk) begin
        wptr <= {wgray[2], wgray[1], wgray[0]};
    end

    always_ff @(posedge rclk) begin
        wptr_syn <= wptr;
    end

    // Define two-stage trigger for read pointer
    always_ff @(posedge rclk) begin
        rptr <= {rgray[2], rgray[1], rgray[0]};
    end

    always_ff @(posedge wclk) begin
        rptr_syn <= rptr;
    end

    // Define full and empty signals
    assign full = (wptr_syn[2] != rptr_syn[2]) & (wptr_syn[1:0] == rptr_syn[1:0]);
    assign empty = (wptr_syn == rptr_syn);

    // Define write and read enables
    assign wen = winc & ~full;
    assign ren = rinc & ~empty;

    // Define output signals
    assign wfull = full;
    assign rempty = empty;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic           wclk,     // Write clock
    input  logic           wenc,     // Write enable
    input  logic [$clog2(DEPTH)-1:0] waddr,  // Write address
    input  logic [WIDTH-1:0] wdata,   // Write data
    input  logic           rclk,     // Read clock
    input  logic           renc,     // Read enable
    input  logic [$clog2(DEPTH)-1:0] raddr,  // Read address
    output logic [WIDTH-1:0] rdata    // Read data
);

    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write operation
    always_ff @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always_ff @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
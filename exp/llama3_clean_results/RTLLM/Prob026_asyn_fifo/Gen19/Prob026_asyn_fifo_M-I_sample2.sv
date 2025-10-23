module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,
    input  logic             wenc,
    input  logic [WIDTH-1:0] wdata,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic             rclk,
    input  logic             renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);

    logic [WIDTH-1:0] ram [DEPTH-1:0];

    always_ff @(posedge wclk) begin
        if (wenc) begin
            ram[waddr] <= wdata;
        end
    end

    always_comb begin
        if (renc) begin
            rdata = ram[raddr];
        end else begin
            rdata = '0;
        end
    end

endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,
    input  logic             wrstn,
    input  logic             rclk,
    input  logic             rrstn,
    input  logic             winc,
    input  logic             rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic             wfull,
    output logic             rempty,
    output logic [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    logic [PTR_WIDTH-1:0] wptr_bin;
    logic [PTR_WIDTH-1:0] rptr_bin;

    // Simplified Gray code conversion
    logic [PTR_WIDTH-1:0] wptr_gray;
    logic [PTR_WIDTH-1:0] rptr_gray;

    assign wptr_gray = {wptr_bin[PTR_WIDTH-1], wptr_bin[PTR_WIDTH-1:1] ^ wptr_bin[PTR_WIDTH-2:0]};
    assign rptr_gray = {rptr_bin[PTR_WIDTH-1], rptr_bin[PTR_WIDTH-1:1] ^ rptr_bin[PTR_WIDTH-2:0]};

    logic wren;
    logic rden;

    assign wren = winc & ~wfull;
    assign rden = rinc & ~rempty;

    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end else if (winc) begin
            wptr_bin <= wptr_bin + 1;
        end
    end

    // Improved two-stage synchronizer for read pointer
    logic [PTR_WIDTH-1:0] rptr_syn1;
    logic [PTR_WIDTH-1:0] rptr_syn2;

    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            rptr_syn1 <= 0;
            rptr_syn2 <= 0;
        end else begin
            rptr_syn1 <= rptr_bin;
            rptr_syn2 <= rptr_syn1;
        end
    end

    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

    // Optimized full and empty signal generation
    assign wfull = (wptr_gray == (rptr_gray + 1) % (1 << PTR_WIDTH));
    assign rempty = (rptr_gray == wptr_gray);

    dual_port_ram #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_instance (
        .wclk(wclk),
        .wenc(wren),
        .wdata(wdata),
        .waddr(wptr_bin),
        .rclk(rclk),
        .renc(rden),
        .raddr(rptr_bin),
        .rdata(rdata)
    );

endmodule
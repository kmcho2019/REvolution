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

    // Dual-port RAM
    logic [WIDTH-1:0] ram [DEPTH-1:0];

    // Write controller
    logic [$clog2(DEPTH)-1:0] waddr_bin;
    logic [$clog2(DEPTH)-1:0] wptr;

    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    always_comb begin
        wptr = (waddr_bin >> 1) ^ waddr_bin;
    end

    // Read controller
    logic [$clog2(DEPTH)-1:0] raddr_bin;
    logic [$clog2(DEPTH)-1:0] rptr;

    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    always_comb begin
        rptr = (raddr_bin >> 1) ^ raddr_bin;
    end

    // Two-stage synchronizers
    logic [1:0] rptr_syn;
    logic [1:0] wptr_syn;

    always_ff @(posedge wclk) begin
        rptr_syn[0] <= rptr[0];
        rptr_syn[1] <= rptr_syn[0];
    end

    always_ff @(posedge rclk) begin
        wptr_syn[0] <= wptr[0];
        wptr_syn[1] <= wptr_syn[0];
    end

    // Full and empty conditions
    assign wfull = (wptr_syn == (rptr_syn ^ 2'b10));
    assign rempty = (rptr_syn == wptr_syn);

    // RAM access
    always_ff @(posedge wclk) begin
        if (winc) begin
            ram[waddr_bin[$clog2(DEPTH)-2:0]] <= wdata;
        end
    end

    always_ff @(posedge rclk) begin
        if (rinc) begin
            rdata <= ram[raddr_bin[$clog2(DEPTH)-2:0]];
        end
    end

endmodule
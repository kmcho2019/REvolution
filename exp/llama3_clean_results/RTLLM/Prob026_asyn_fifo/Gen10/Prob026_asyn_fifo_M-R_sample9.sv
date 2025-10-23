module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,
    input  logic             rclk,
    input  logic             wrstn,
    input  logic             rrstn,
    input  logic             winc,
    input  logic             rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic             wfull,
    output logic             rempty,
    output logic [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    logic [WIDTH-1:0] ram [DEPTH-1:0];

    logic [PTR_WIDTH-1:0] wptr;
    logic [PTR_WIDTH-1:0] rptr;

    logic [PTR_WIDTH-1:0] wptr_sync;
    logic [PTR_WIDTH-1:0] rptr_sync;

    logic wren;
    logic rden;

    assign wren = winc & ~wfull;
    assign rden = rinc & ~rempty;

    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            wptr <= 0;
        end else if (winc) begin
            wptr <= wptr + 1;
        end
    end

    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            rptr <= 0;
        end else if (rinc) begin
            rptr <= rptr + 1;
        end
    end

    // Read pointer synchronizer
    logic [1:0] rptr_sync_reg;
    always_ff @(posedge wclk) begin
        rptr_sync_reg <= {rptr_sync_reg[0], rptr};
    end
    assign rptr_sync = rptr_sync_reg[1];

    // Write pointer synchronizer
    logic [1:0] wptr_sync_reg;
    always_ff @(posedge rclk) begin
        wptr_sync_reg <= {wptr_sync_reg[0], wptr};
    end
    assign wptr_sync = wptr_sync_reg[1];

    // Gray code conversion
    logic [PTR_WIDTH-1:0] wptr_gray;
    logic [PTR_WIDTH-1:0] rptr_gray;

    assign wptr_gray = (wptr >> 1) ^ wptr;
    assign rptr_gray = (rptr >> 1) ^ rptr;

    assign wfull = (wptr_gray == (rptr_gray + 1)) | (wptr_gray == 0 & rptr_gray == DEPTH - 1);
    assign rempty = (rptr_gray == wptr_gray) | (rptr_gray == DEPTH - 1 & wptr_gray == 0);

    assign rdata = ram[rptr];

    always_ff @(posedge wclk) begin
        if (wren) begin
            ram[wptr] <= wdata;
        end
    end

endmodule
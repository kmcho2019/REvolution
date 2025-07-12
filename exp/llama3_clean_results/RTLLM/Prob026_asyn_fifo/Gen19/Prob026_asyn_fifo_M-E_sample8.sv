module token_based_async_fifo #(
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

    // Token generator
    logic [WIDTH-1:0] token;
    logic             token_valid;

    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            token <= 0;
            token_valid <= 0;
        end else if (winc) begin
            token <= token + 1;
            token_valid <= 1;
        end
    end

    // Token RAM
    logic [WIDTH-1:0] token_ram [DEPTH-1:0];

    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            token_ram[0] <= 0;
        end else if (winc) begin
            token_ram[wptr_bin] <= token;
        end
    end

    // Dual-port RAM
    logic [WIDTH-1:0] data_ram [DEPTH-1:0];

    always_ff @(posedge wclk) begin
        if (~wrstn) begin
            data_ram[0] <= 0;
        end else if (winc) begin
            data_ram[wptr_bin] <= wdata;
        end
    end

    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            rdata <= 0;
        end else if (rinc) begin
            rdata <= data_ram[rptr_bin];
        end
    end

    // Token-based control
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

    always_ff @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

    // Full and empty signals
    assign wfull = (wptr_bin == DEPTH - 1);
    assign rempty = (rptr_bin == 0);

    // Output connections
    assign rdata = data_ram[rptr_bin];

endmodule
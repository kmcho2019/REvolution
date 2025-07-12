module asyn_fifo
    #(
        parameter WIDTH = 8,
        parameter DEPTH = 16
    )
    (
        input   logic               wclk,
        input   logic               rstn,
        input   logic               wrstn,
        input   logic               rrstn,
        input   logic               winc,
        input   logic               rinc,
        input   logic   [WIDTH-1:0] wdata,
        output  logic               wfull,
        output  logic               rempty,
        output  logic   [WIDTH-1:0] rdata
    );

    logic   [WIDTH-1:0]  RAM_MEM [DEPTH-1:0];

    logic   [3:0]        wptr_bin;
    logic   [3:0]        rptr_bin;
    logic   [3:0]        wptr_bin_reg;
    logic   [3:0]        rptr_bin_reg;

    logic   [3:0]        wptr;
    logic   [3:0]        rptr;
    logic   [3:0]        wptr_syn;
    logic   [3:0]        rptr_syn;

    logic   [WIDTH-1:0]  rdata_reg;

    // Dual-Port RAM
    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end
        else if (winc) begin
            wptr_bin <= wptr_bin + 1;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end
        else if (rinc) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

    // Gray Code Conversion
    assign wptr = {wptr_bin[3] ^ wptr_bin[2], wptr_bin[2] ^ wptr_bin[1], wptr_bin[1] ^ wptr_bin[0], wptr_bin[0]};
    assign rptr = {rptr_bin[3] ^ rptr_bin[2], rptr_bin[2] ^ rptr_bin[1], rptr_bin[1] ^ rptr_bin[0], rptr_bin[0]};

    // Pointer Buffers
    always @(posedge wclk) begin
        wptr_bin_reg <= wptr_bin;
    end

    always @(posedge rclk) begin
        rptr_bin_reg <= rptr_bin;
    end

    // Synchronization
    logic   [3:0]        wptr_sync1;
    logic   [3:0]        wptr_sync2;
    always @(posedge rclk) begin
        wptr_sync1 <= wptr;
    end

    always @(posedge rclk) begin
        wptr_sync2 <= wptr_sync1;
    end

    assign wptr_syn = wptr_sync2;

    logic   [3:0]        rptr_sync1;
    logic   [3:0]        rptr_sync2;
    always @(posedge wclk) begin
        rptr_sync1 <= rptr;
    end

    always @(posedge wclk) begin
        rptr_sync2 <= rptr_sync1;
    end

    assign rptr_syn = rptr_sync2;

    // RAM Access
    always @(posedge wclk) begin
        if (winc) begin
            RAM_MEM[wptr_bin_reg] <= wdata;
        end
    end

    always @(posedge rclk) begin
        rdata_reg <= RAM_MEM[rptr_bin_reg];
    end

    assign rdata = rdata_reg;

    // Full and Empty Detection
    assign wfull = (wptr_syn == {~rptr_syn[3], rptr_syn[2:0]});
    assign rempty = (rptr == wptr);

endmodule
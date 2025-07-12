module asyn_fifo (
    input               wclk,         // Write clock
    input               rclk,         // Read clock
    input               wrstn,        // Write reset (active low)
    input               rrstn,        // Read reset (active low)
    input               winc,         // Write increment
    input               rinc,         // Read increment
    input  [WIDTH-1:0]  wdata,        // Write data
    output reg          wfull,        // Write full
    output reg          rempty,       // Read empty
    output reg [WIDTH-1:0] rdata       // Read data
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Dual-port RAM
    reg [WIDTH-1:0] rdata_out;
    reg              wenc, renc;
    reg [$clog2(DEPTH)-1:0] waddr, raddr;

    // Write pointer
    reg [$clog2(DEPTH)-1:0] wptr_bin;
    reg [$clog2(DEPTH)-1:0] wptr_buff;
    reg [3:0] wptr;

    // Read pointer
    reg [$clog2(DEPTH)-1:0] rptr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_buff;
    reg [3:0] rptr, rptr_syn;

    // Write controller
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin <= 0;
            wenc <= 0;
        end else if (winc) begin
            wptr_bin <= wptr_bin + 1;
            wenc <= 1;
        end else begin
            wenc <= 0;
        end
    end

    // Read controller
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin <= 0;
            renc <= 0;
        end else if (rinc) begin
            rptr_bin <= rptr_bin + 1;
            renc <= 1;
        end else begin
            renc <= 0;
        end
    end

    // Write pointer to Gray code conversion
    always @(*) begin
        wptr[0] = wptr_bin[0];
        wptr[1] = wptr_bin[1] ^ wptr_bin[0];
        wptr[2] = wptr_bin[2] ^ wptr_bin[1];
        wptr[3] = wptr_bin[3] ^ wptr_bin[2];
    end

    // Read pointer to Gray code conversion
    always @(*) begin
        rptr[0] = rptr_bin[0];
        rptr[1] = rptr_bin[1] ^ rptr_bin[0];
        rptr[2] = rptr_bin[2] ^ rptr_bin[1];
        rptr[3] = rptr_bin[3] ^ rptr_bin[2];
    end

    // Write pointer synchronizer
    reg [3:0] wptr_sync;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_sync <= 0;
        end else begin
            wptr_sync <= wptr;
        end
    end

    // Read pointer synchronizer
    reg [3:0] rptr_sync;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_sync <= 0;
        end else begin
            rptr_sync <= rptr;
        end
    end

    // Full and empty signals
    always @(*) begin
        wfull = (wptr_sync[3]!= rptr[3]) && (wptr_sync[2:0] == rptr[2:0]);
        rempty = (rptr_syn == wptr);
    end

    // Read pointer synchronizer (two-stage trigger)
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

    // RAM access
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata_out <= RAM_MEM[raddr];
        end
    end

    // RAM address generation
    always @(*) begin
        waddr = wptr_bin[$clog2(DEPTH)-1:0];
        raddr = rptr_bin[$clog2(DEPTH)-1:0];
    end

    // Output assignment
    always @(*) begin
        rdata = rdata_out;
    end

endmodule
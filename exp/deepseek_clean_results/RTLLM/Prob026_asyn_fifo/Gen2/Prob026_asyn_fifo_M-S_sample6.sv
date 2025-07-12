module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // FIFO memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers
    reg [ADDR_WIDTH:0] wptr, rptr;
    wire [ADDR_WIDTH:0] wptr_gray = wptr ^ (wptr >> 1);
    wire [ADDR_WIDTH:0] rptr_gray = rptr ^ (rptr >> 1);

    // Synchronized pointers
    reg [ADDR_WIDTH:0] wptr_sync, rptr_sync;

    // Write logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (winc && !wfull) begin
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
            wptr <= wptr + 1;
        end
    end

    // Read logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rdata <= 0;
        end else if (rinc && !rempty) begin
            rdata <= mem[rptr[ADDR_WIDTH-1:0]];
            rptr <= rptr + 1;
        end
    end

    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync <= 0;
        end else begin
            rptr_sync <= rptr_gray;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync <= 0;
        end else begin
            wptr_sync <= wptr_gray;
        end
    end

    // Full/empty generation
    always @(*) begin
        rempty = (rptr_gray == wptr_sync);
        wfull = (wptr_gray == {~rptr_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                              rptr_sync[ADDR_WIDTH-2:0]});
    end

endmodule
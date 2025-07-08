```thought
To implement the asynchronous FIFO, we instantiate a dual-port RAM module with separate clocks for read and write. The FIFO uses binary write and read pointers which are converted to Gray code to reduce synchronization issues. The read pointer is synchronized into the write clock domain using a two-stage synchronizer and vice versa for the write pointer. These synchronized pointers are used to generate full and empty flags by comparing Gray-coded pointers according to the described logic. The RAM address is derived from the lower bits of the binary pointers converted from Gray code pointers. The write pointer increments on winc when FIFO is not full, and the read pointer increments on rinc when FIFO is not empty. The dual-port RAM handles data storage with separate read and write ports. This structured approach cleanly separates RAM, pointer management, synchronization, and status flags for robust asynchronous FIFO operation.
```
```code
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,
    input                  rrstn,
    input                  winc,
    input                  rinc,
    input      [WIDTH-1:0] wdata,
    output                 wfull,
    output                 rempty,
    output     [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // One extra bit for full detection (e.g., 5 bits for DEPTH=16)

    // -----------------------------------
    // Dual-port RAM module instantiation
    // -----------------------------------
    wire                    wenc;
    wire                    renc;
    wire [ADDR_WIDTH-1:0]   waddr;
    wire [ADDR_WIDTH-1:0]   raddr;
    wire [WIDTH-1:0]        ram_rdata;

    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk (wclk),
        .wenc (wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk (rclk),
        .renc (renc),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -----------------------------------
    // Write pointer binary and gray code
    // -----------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_bin_next;
    reg [PTR_WIDTH-1:0] wptr, wptr_next; // Gray code write pointer

    // Increment write pointer if winc and not full
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr     <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr     <= wptr_next;
        end
    end

    always @(*) begin
        if (winc && !wfull) begin
            wptr_bin_next = wptr_bin + 1'b1;
        end else begin
            wptr_bin_next = wptr_bin;
        end
        // Binary to Gray code
        wptr_next = (wptr_bin_next >> 1) ^ wptr_bin_next;
    end

    // -----------------------------------
    // Read pointer binary and gray code
    // -----------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_bin_next;
    reg [PTR_WIDTH-1:0] rptr, rptr_next; // Gray code read pointer

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr     <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr     <= rptr_next;
        end
    end

    always @(*) begin
        if (rinc && !rempty) begin
            rptr_bin_next = rptr_bin + 1'b1;
        end else begin
            rptr_bin_next = rptr_bin;
        end
        // Binary to Gray code
        rptr_next = (rptr_bin_next >> 1) ^ rptr_bin_next;
    end

    // -----------------------------------
    // Synchronize read pointer into write clock domain (for full detection)
    // 2-stage synchronizer for rptr
    // -----------------------------------
    reg [PTR_WIDTH-1:0] rptr_sync_0, rptr_sync_1;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync_0 <= 0;
            rptr_sync_1 <= 0;
        end else begin
            rptr_sync_0 <= rptr;
            rptr_sync_1 <= rptr_sync_0;
        end
    end

    wire [PTR_WIDTH-1:0] rptr_sync_wclk = rptr_sync_1;

    // -----------------------------------
    // Synchronize write pointer into read clock domain (for empty detection)
    // 2-stage synchronizer for wptr
    // -----------------------------------
    reg [PTR_WIDTH-1:0] wptr_sync_0, wptr_sync_1;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync_0 <= 0;
            wptr_sync_1 <= 0;
        end else begin
            wptr_sync_0 <= wptr;
            wptr_sync_1 <= wptr_sync_0;
        end
    end

    wire [PTR_WIDTH-1:0] wptr_sync_rclk = wptr_sync_1;

    // -----------------------------------
    // Convert Gray code to binary function
    // -----------------------------------
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // -----------------------------------
    // Decode addresses for RAM from Gray pointers (lower ADDR_WIDTH bits of binary pointer)
    // -----------------------------------
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // -----------------------------------
    // RAM write enable and read enable signals
    // Write enable when winc and not full
    // Read enable when rinc and not empty
    // -----------------------------------
    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;

    // -----------------------------------
    // FIFO full and empty logic:
    // full  when (wptr_bin + 1 == rptr_sync_wclk_bin) with MSB bit inverted check:
    // Compare Gray code pointers as per full condition:
    // full if:
    //  wptr[PTR_WIDTH-1] != rptr_sync_wclk[PTR_WIDTH-1]
    //  wptr[PTR_WIDTH-2] != rptr_sync_wclk[PTR_WIDTH-2]
    //  wptr[PTR_WIDTH-3:0] == rptr_sync_wclk[PTR_WIDTH-3:0]
    //
    // empty when wptr_sync_rclk == rptr (Gray code pointers equal)
    // -----------------------------------

    // For full detection, need to compare Gray pointers:
    // full if:
    //  (wptr[PTR_WIDTH-1] != rptr_sync_wclk[PTR_WIDTH-1]) &&
    //  (wptr[PTR_WIDTH-2] != rptr_sync_wclk[PTR_WIDTH-2]) &&
    //  (wptr[PTR_WIDTH-3:0] == rptr_sync_wclk[PTR_WIDTH-3:0])

    wire full_cond = ((wptr[PTR_WIDTH-1] != rptr_sync_wclk[PTR_WIDTH-1]) &&
                      (wptr[PTR_WIDTH-2] != rptr_sync_wclk[PTR_WIDTH-2]) &&
                      (wptr[PTR_WIDTH-3:0] == rptr_sync_wclk[PTR_WIDTH-3:0]));

    assign wfull = full_cond;

    // Empty if Gray-coded pointers equal after synchronization
    assign rempty = (rptr == wptr_sync_rclk);

    // -----------------------------------
    // Output read data from RAM
    // -----------------------------------
    assign rdata = ram_rdata;

endmodule


// -----------------------------------
// Dual-port RAM module definition
// -----------------------------------
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port
    always @(posedge rclk) begin
        if (renc

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)

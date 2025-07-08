```thought
Implement an asynchronous FIFO with configurable depth and width, using a dual-port RAM submodule. Maintain separate write and read pointers in binary and Gray code, with two-stage synchronizers for crossing clock domains. The FIFO full and empty flags are derived from Gray-coded pointers using the conventional method: empty when read pointer equals write pointer; full when the write pointer is one cycle ahead of read pointer with inverted MSBs. The RAM address is taken from the lower bits of the binary pointer. Provide all necessary pointer increments, synchronizations, and control signals for writing and reading data. Use parameters for WIDTH and DEPTH and ensure proper reset handling for write and read clocks.

The structure includes:
- dual_port_RAM: parameterized RAM with separate clocks and ports,
- write controller: manages write pointer and write enable,
- read controller: manages read pointer and read enable,
- pointer synchronizers: two-stage flip-flop synchronizers for crossing clock domains,
- logic for empty/full flags using Gray code pointers.

Use $clog2(DEPTH) for pointer width and address width, use 4-bit Gray code for DEPTH=16 (depth=16 requires 4-bit pointers).
```
```code
`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input               wclk,
    input               rclk,
    input               wrstn,
    input               rrstn,
    input               winc,
    input               rinc,
    input  [WIDTH-1:0]  wdata,
    output              wfull,
    output              rempty,
    output [WIDTH-1:0]  rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);        // number of bits for address
    localparam ADDR_WIDTH = PTR_WIDTH;

    // ----------------------
    // dual-port RAM submodule
    // ----------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(winc & (~wfull)),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & (~rempty)),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    // ----------------------
    // Write pointer (binary and gray)
    // ----------------------
    reg [PTR_WIDTH:0] wptr_bin;   // extra bit for full detection (wraparound)
    wire [PTR_WIDTH:0] wptr_gray;
    reg [PTR_WIDTH:0] wptr_gray_buff1, wptr_gray_buff2; // for synchronizing to read clock domain

    // ----------------------
    // Read pointer (binary and gray)
    // ----------------------
    reg [PTR_WIDTH:0] rptr_bin;   // extra bit for full detection (wraparound)
    wire [PTR_WIDTH:0] rptr_gray;
    reg [PTR_WIDTH:0] rptr_gray_buff1, rptr_gray_buff2; // for synchronizing to write clock domain

    // ----------------------
    // Synchronized pointers (cross clock domain)
    // ----------------------
    reg [PTR_WIDTH:0] rptr_gray_sync; // read pointer synchronized into write clock domain
    reg [PTR_WIDTH:0] wptr_gray_sync; // write pointer synchronized into read clock domain

    // ----------------------
    // Addresses from binary pointers (lower bits)
    // ----------------------
    wire [ADDR_WIDTH-1:0] waddr_bin = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_bin = rptr_bin[ADDR_WIDTH-1:0];

    // ----------------------
    // Gray code conversion function
    // ----------------------
    function [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // ----------------------
    // Gray to binary conversion function
    // Used only for comparison in empty/full detection, but we compare gray directly, so not strictly needed here.
    // ----------------------
    function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i=PTR_WIDTH-1; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // ----------------------
    // Write pointer logic
    // ----------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray_buff1 <= 0;
            wptr_gray_buff2 <= 0;
        end else begin
            // increment write pointer if write increment and not full
            if (winc && ~wfull) begin
                wptr_bin <= wptr_bin + 1'b1;
            end
            wptr_gray_buff1 <= bin2gray(wptr_bin);
            wptr_gray_buff2 <= wptr_gray_buff1;
        end
    end

    assign wptr_gray = wptr_gray_buff2;

    // ----------------------
    // Read pointer logic
    // ----------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray_buff1 <= 0;
            rptr_gray_buff2 <= 0;
        end else begin
            if (rinc && ~rempty) begin
                rptr_bin <= rptr_bin + 1'b1;
            end
            rptr_gray_buff1 <= bin2gray(rptr_bin);
            rptr_gray_buff2 <= rptr_gray_buff1;
        end
    end

    assign rptr_gray = rptr_gray_buff2;

    // ----------------------
    // Synchronize read pointer into write clock domain
    // ----------------------
    reg [PTR_WIDTH:0] rptr_gray_sync_stage1, rptr_gray_sync_stage2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_stage1 <= 0;
            rptr_gray_sync_stage2 <= 0;
            rptr_gray_sync <= 0;
        end else begin
            rptr_gray_sync_stage1 <= rptr_gray;
            rptr_gray_sync_stage2 <= rptr_gray_sync_stage1;
            rptr_gray_sync <= rptr_gray_sync_stage2;
        end
    end

    // ----------------------
    // Synchronize write pointer into read clock domain
    // ----------------------
    reg [PTR_WIDTH:0] wptr_gray_sync_stage1, wptr_gray_sync_stage2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_stage1 <= 0;
            wptr_gray_sync_stage2 <= 0;
            wptr_gray_sync <= 0;
        end else begin
            wptr_gray_sync_stage1 <= wptr_gray;
            wptr_gray_sync_stage2 <= wptr_gray_sync_stage1;
            wptr_gray_sync <= wptr_gray_sync_stage2;
        end
    end

    // ----------------------
    // FIFO empty and full detection
    // Empty: when read pointer == synchronized write pointer (both in Gray code)
    // Full: when write pointer == (read pointer with MSBs inverted and rest equal)
    // For DEPTH=16 (4 bits pointers), full condition:
    // wptr_gray[PTR_WIDTH]      == ~rptr_gray_sync[PTR_WIDTH]
    // wptr_gray[PTR_WIDTH-1]    == ~rptr_gray_sync[PTR_WIDTH-1]
    // wptr_gray[PTR_WIDTH-2:0]  == rptr_gray_sync[PTR_WIDTH-2:0]
    // ----------------------

    // Empty signal (read side)
    assign rempty = (rptr_gray == wptr_gray_sync);

    // Full signal (write side)
    wire msb_invert_cond = (wptr_gray[PTR_WIDTH]   == ~rptr_gray_sync[PTR_WIDTH]) &&
                          (wptr_gray[PTR_WIDTH-1] == ~rptr_gray_sync[PTR_WIDTH-1]);
    wire lsb_equal_cond = (wptr_gray[PTR_WIDTH-2:0] == rptr_gray_sync[PTR_WIDTH-2:0]);
    assign wfull = msb_invert_cond && lsb_equal_cond;

endmodule


// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

    // Memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    // Asynchronous read is not required, read synchronous with rclk and renc
    always @(posedge rclk) begin

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)

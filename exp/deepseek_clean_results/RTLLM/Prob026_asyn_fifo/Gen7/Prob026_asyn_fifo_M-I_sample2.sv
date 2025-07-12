module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ALMOST_FULL_THRESH = 12,
    parameter ALMOST_EMPTY_THRESH = 4,
    parameter SYNC_STAGES = 2       // Reduced from 3 to 2 for optimization
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
    output reg almost_full,
    output reg almost_empty,
    output [WIDTH-1:0] rdata
);

    // Validate parameters
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface signals
    wire wen;
    wire ren;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Pointer signals
    wire [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray;
    
    // Synchronized pointers
    wire [PTR_WIDTH-1:0] wptr_gray_sync;
    wire [PTR_WIDTH-1:0] rptr_gray_sync;

    // Control signals
    assign wen = winc && !wfull;
    assign ren = rinc && !rempty;

    // Instantiate memory
    dp_mem #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    u_mem (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write Controller
    write_ctrl #(
        .PTR_WIDTH(PTR_WIDTH),
        .SYNC_STAGES(SYNC_STAGES),
        .ALMOST_THRESH(ALMOST_FULL_THRESH))
    u_write_ctrl (
        .clk(wclk),
        .rstn(wrstn),
        .inc(wen),
        .rptr_gray_sync(rptr_gray_sync),
        .wptr_bin(wptr_bin),
        .wptr_gray(wptr_gray),
        .waddr(waddr),
        .wfull(wfull),
        .almost_full(almost_full)
    );

    // Read Controller
    read_ctrl #(
        .PTR_WIDTH(PTR_WIDTH),
        .SYNC_STAGES(SYNC_STAGES),
        .ALMOST_THRESH(ALMOST_EMPTY_THRESH))
    u_read_ctrl (
        .clk(rclk),
        .rstn(rrstn),
        .inc(ren),
        .wptr_gray_sync(wptr_gray_sync),
        .rptr_bin(rptr_bin),
        .rptr_gray(rptr_gray),
        .raddr(raddr),
        .rempty(rempty),
        .almost_empty(almost_empty)
    );

    // Cross-domain synchronizers
    sync_chain #(
        .WIDTH(PTR_WIDTH),
        .STAGES(SYNC_STAGES))
    u_sync_w2r (
        .clk(rclk),
        .rstn(rrstn),
        .d(wptr_gray),
        .q(wptr_gray_sync)
    );

    sync_chain #(
        .WIDTH(PTR_WIDTH),
        .STAGES(SYNC_STAGES))
    u_sync_r2w (
        .clk(wclk),
        .rstn(wrstn),
        .d(rptr_gray),
        .q(rptr_gray_sync)
    );

endmodule

// Dual-port memory with initialization
module dp_mem #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i+1)
            mem[i] = 0;
    end
    
    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];
endmodule

// Write controller with optimized flag generation
module write_ctrl #(
    parameter PTR_WIDTH = 5,
    parameter SYNC_STAGES = 2,
    parameter ALMOST_THRESH = 12
) (
    input clk,
    input rstn,
    input inc,
    input [PTR_WIDTH-1:0] rptr_gray_sync,
    output reg [PTR_WIDTH-1:0] wptr_bin,
    output reg [PTR_WIDTH-1:0] wptr_gray,
    output [$clog2(2**PTR_WIDTH-1)-1:0] waddr,
    output reg wfull,
    output reg almost_full
);
    // Binary and Gray code pointers
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + inc;
    wire [PTR_WIDTH-1:0] wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;
    
    assign waddr = wptr_bin[PTR_WIDTH-2:0];  // Use lower bits for address
    
    // Convert synchronized read pointer to binary
    wire [PTR_WIDTH-1:0] rptr_bin_sync;
    gray2bin #(PTR_WIDTH) u_g2b_rptr (.gray(rptr_gray_sync), .bin(rptr_bin_sync));
    
    // Flag generation
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wfull <= 0;
            almost_full <= 0;
        end else begin
            if (inc && !wfull) begin
                wptr_bin <= wptr_bin_next;
                wptr_gray <= wptr_gray_next;
            end
            
            // Optimized full detection
            wfull <= (wptr_gray_next == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                       rptr_gray_sync[PTR_WIDTH-3:0]});
            
            // Optimized almost full
            almost_full <= (wptr_bin - rptr_bin_sync) >= ALMOST_THRESH[PTR_WIDTH-1:0];
        end
    end
endmodule

// Read controller with optimized flag generation
module read_ctrl #(
    parameter PTR_WIDTH = 5,
    parameter SYNC_STAGES = 2,
    parameter ALMOST_THRESH = 4
) (
    input clk,
    input rstn,
    input inc,
    input [PTR_WIDTH-1:0] wptr_gray_sync,
    output reg [PTR_WIDTH-1:0] rptr_bin,
    output reg [PTR_WIDTH-1:0] rptr_gray,
    output [$clog2(2**PTR_WIDTH-1)-1:0] raddr,
    output reg rempty,
    output reg almost_empty
);
    // Binary and Gray code pointers
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + inc;
    wire [PTR_WIDTH-1:0] rptr_gray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;
    
    assign raddr = rptr_bin[PTR_WIDTH-2:0];  // Use lower bits for address
    
    // Convert synchronized write pointer to binary
    wire [PTR_WIDTH-1:0] wptr_bin_sync;
    gray2bin #(PTR_WIDTH) u_g2b_wptr (.gray(wptr_gray_sync), .bin(wptr_bin_sync));
    
    // Flag generation
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rempty <= 1;
            almost_empty <= 1;
        end else begin
            if (inc && !rempty) begin
                rptr_bin <= rptr_bin_next;
                rptr_gray <= rptr_gray_next;
            end
            
            // Optimized empty detection
            rempty <= (rptr_gray_next == wptr_gray_sync);
            
            // Optimized almost empty
            almost_empty <= (wptr_bin_sync - rptr_bin) <= ALMOST_THRESH[PTR_WIDTH-1:0];
        end
    end
endmodule

// Gray to binary converter (unchanged)
module gray2bin #(
    parameter WIDTH = 5
) (
    input [WIDTH-1:0] gray,
    output [WIDTH-1:0] bin
);
    genvar i;
    generate
        assign bin[WIDTH-1] = gray[WIDTH-1];
        for (i = WIDTH-2; i >= 0; i = i-1) begin : gen_loop
            assign bin[i] = bin[i+1] ^ gray[i];
        end
    endgenerate
endmodule

// Configurable synchronizer chain (optimized)
module sync_chain #(
    parameter WIDTH = 5,
    parameter STAGES = 2  // Reduced default
) (
    input clk,
    input rstn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    reg [WIDTH-1:0] sync_reg [0:STAGES-1];
    integer i;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (i = 0; i < STAGES; i = i+1)
                sync_reg[i] <= 0;
            q <= 0;
        end else begin
            sync_reg[0] <= d;
            for (i = 1; i < STAGES; i = i+1)
                sync_reg[i] <= sync_reg[i-1];
            q <= sync_reg[STAGES-1];
        end
    end
endmodule
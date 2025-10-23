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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    // Validate parameters
    generate
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            initial begin
                $error("Error: DEPTH must be power of 2");
                $finish;
            end
        end
    endgenerate

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ===========================================
    // Write Domain Logic
    // ===========================================
    wire [PTR_WIDTH-1:0] wptr_gray, wptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_synced;
    reg [PTR_WIDTH-1:0] wptr_bin;

    // Binary pointer increment
    assign wptr_bin_next = wptr_bin + 1'b1;

    // Gray code conversion
    assign wptr_gray = wptr_bin ^ (wptr_bin >> 1);

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // Read pointer synchronizer
    sync_cell #(.WIDTH(PTR_WIDTH)) u_wr_sync (
        .clk(wclk),
        .rstn(wrstn),
        .d(rptr_gray),
        .q(rptr_synced)
    );

    // Full detection
    assign wfull = (wptr_gray == {~rptr_synced[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_synced[PTR_WIDTH-3:0]});

    // ===========================================
    // Read Domain Logic
    // ===========================================
    wire [PTR_WIDTH-1:0] rptr_gray, rptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_synced;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Binary pointer increment
    assign rptr_bin_next = rptr_bin + 1'b1;

    // Gray code conversion
    assign rptr_gray = rptr_bin ^ (rptr_bin >> 1);

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
        end
    end

    // Write pointer synchronizer
    sync_cell #(.WIDTH(PTR_WIDTH)) u_rw_sync (
        .clk(rclk),
        .rstn(rrstn),
        .d(wptr_gray),
        .q(wptr_synced)
    );

    // Empty detection
    assign rempty = (rptr_gray == wptr_synced);

    // ===========================================
    // Memory Interface
    // ===========================================
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule

// Synchronizer cell with parameterized width
module sync_cell #(
    parameter WIDTH = 4
) (
    input clk,
    input rstn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    reg [WIDTH-1:0] sync_reg1, sync_reg2;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            {sync_reg2, sync_reg1} <= 0;
            q <= 0;
        end else begin
            sync_reg1 <= d;
            sync_reg2 <= sync_reg1;
            q <= sync_reg2;
        end
    end

endmodule

// Simplified dual-port RAM
module dual_port_ram #(
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

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
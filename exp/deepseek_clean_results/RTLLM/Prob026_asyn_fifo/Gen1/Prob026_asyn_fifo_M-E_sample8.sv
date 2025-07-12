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
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 2; // Extra bits for quadrant tracking

    // Quadrant definitions
    localparam Q0 = 2'b00, Q1 = 2'b01, Q2 = 2'b10, Q3 = 2'b11;

    // Dual-port RAM
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [1:0] wptr_quad = Q0;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wptr_quad <= Q0;
        end else if (wenc) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
            wptr_quad <= (wptr_bin[PTR_WIDTH-1:PTR_WIDTH-2] + 1) & 2'b11;
        end
    end

    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [1:0] rptr_quad = Q0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rptr_quad <= Q0;
        end else if (renc) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
            rptr_quad <= (rptr_bin[PTR_WIDTH-1:PTR_WIDTH-2] + 1) & 2'b11;
        end
    end

    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Hierarchical synchronization
    reg [PTR_WIDTH-1:0] wptr_sync [0:2];
    reg [PTR_WIDTH-1:0] rptr_sync [0:2];
    reg [1:0] wptr_quad_sync [0:2];
    reg [1:0] rptr_quad_sync [0:2];

    // Sync write pointer to read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wptr_sync[2] <= 0;
            wptr_quad_sync[0] <= Q0;
            wptr_quad_sync[1] <= Q0;
            wptr_quad_sync[2] <= Q0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
            wptr_sync[2] <= wptr_sync[1];
            wptr_quad_sync[0] <= wptr_quad;
            wptr_quad_sync[1] <= wptr_quad_sync[0];
            wptr_quad_sync[2] <= wptr_quad_sync[1];
        end
    end

    // Sync read pointer to write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rptr_sync[2] <= 0;
            rptr_quad_sync[0] <= Q0;
            rptr_quad_sync[1] <= Q0;
            rptr_quad_sync[2] <= Q0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
            rptr_sync[2] <= rptr_sync[1];
            rptr_quad_sync[0] <= rptr_quad;
            rptr_quad_sync[1] <= rptr_quad_sync[0];
            rptr_quad_sync[2] <= rptr_quad_sync[1];
        end
    end

    // Predictive full/empty detection using quadrants
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            // Full when write quadrant is one ahead and pointers match
            wfull <= (wptr_quad == (rptr_quad_sync[2] + 1) & 
                    (wptr_gray[PTR_WIDTH-3:0] == rptr_sync[2][PTR_WIDTH-3:0]));
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            // Empty when quadrants match and pointers match
            rempty <= (rptr_quad == wptr_quad_sync[2]) && 
                     (rptr_gray[PTR_WIDTH-3:0] == wptr_sync[2][PTR_WIDTH-3:0]);
        end
    end

endmodule

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

    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
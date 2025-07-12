// Dual-port RAM module
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
    
    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end
    
    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end
endmodule

// 2-stage synchronizer module
module sync_2stage #(
    parameter WIDTH = 4
) (
    input clk,
    input rstn,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout
);
    reg [WIDTH-1:0] sync_reg;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_reg <= 0;
            dout <= 0;
        end else begin
            sync_reg <= din;
            dout <= sync_reg;
        end
    end
endmodule

// Write controller
module write_ctrl #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wrstn,
    input winc,
    input [WIDTH:0] rptr_sync,
    output reg wfull,
    output reg [$clog2(DEPTH):0] waddr,
    output reg wenc
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    wire [ADDR_WIDTH:0] wptr_gray;
    wire [ADDR_WIDTH:0] wptr_next = waddr + 1;
    
    // Gray code conversion
    assign wptr_gray = wptr_next ^ (wptr_next >> 1);
    
    // Full detection
    wire full = (wptr_gray == {~rptr_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                              rptr_sync[ADDR_WIDTH-2:0]});
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr <= 0;
            wfull <= 0;
            wenc <= 0;
        end else begin
            wfull <= full;
            wenc <= winc && !full;
            
            if (winc && !full) begin
                waddr <= wptr_next;
            end
        end
    end
endmodule

// Read controller
module read_ctrl #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input rclk,
    input rrstn,
    input rinc,
    input [WIDTH:0] wptr_sync,
    output reg rempty,
    output reg [$clog2(DEPTH):0] raddr,
    output reg renc
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    wire [ADDR_WIDTH:0] rptr_gray;
    wire [ADDR_WIDTH:0] rptr_next = raddr + 1;
    
    // Gray code conversion
    assign rptr_gray = rptr_next ^ (rptr_next >> 1);
    
    // Empty detection
    wire empty = (rptr_gray == wptr_sync);
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr <= 0;
            rempty <= 1;
            renc <= 0;
        end else begin
            rempty <= empty;
            renc <= rinc && !empty;
            
            if (rinc && !empty) begin
                raddr <= rptr_next;
            end
        end
    end
endmodule

// Top-level asynchronous FIFO
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
    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Write domain signals
    wire [ADDR_WIDTH:0] waddr;
    wire wenc;
    
    // Read domain signals
    wire [ADDR_WIDTH:0] raddr;
    wire renc;
    
    // Synchronized pointers
    wire [ADDR_WIDTH:0] wptr_gray;
    wire [ADDR_WIDTH:0] rptr_gray;
    wire [ADDR_WIDTH:0] wptr_sync;
    wire [ADDR_WIDTH:0] rptr_sync;
    
    // Gray code conversions
    assign wptr_gray = (waddr + 1) ^ ((waddr + 1) >> 1);
    assign rptr_gray = (raddr + 1) ^ ((raddr + 1) >> 1);
    
    // Instantiate modules
    dual_port_ram #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
    
    write_ctrl #(.WIDTH(WIDTH), .DEPTH(DEPTH)) wctrl (
        .wclk(wclk),
        .wrstn(wrstn),
        .winc(winc),
        .rptr_sync(rptr_sync),
        .wfull(wfull),
        .waddr(waddr),
        .wenc(wenc)
    );
    
    read_ctrl #(.WIDTH(WIDTH), .DEPTH(DEPTH)) rctrl (
        .rclk(rclk),
        .rrstn(rrstn),
        .rinc(rinc),
        .wptr_sync(wptr_sync),
        .rempty(rempty),
        .raddr(raddr),
        .renc(renc)
    );
    
    // Pointer synchronizers
    sync_2stage #(.WIDTH(ADDR_WIDTH+1)) w2r_sync (
        .clk(rclk),
        .rstn(rrstn),
        .din(wptr_gray),
        .dout(wptr_sync)
    );
    
    sync_2stage #(.WIDTH(ADDR_WIDTH+1)) r2w_sync (
        .clk(wclk),
        .rstn(wrstn),
        .din(rptr_gray),
        .dout(rptr_sync)
    );
endmodule
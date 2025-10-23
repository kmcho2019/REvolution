module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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
    
    // RAM interface signals
    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    
    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );
    
    // Pointer logic
    wire [ADDR_WIDTH:0] wptr, rptr;
    wire [ADDR_WIDTH:0] wgray, rgray;
    wire [ADDR_WIDTH:0] wgray_sync, rgray_sync;
    
    // Write pointer control
    ptr_ctrl #(
        .WIDTH(ADDR_WIDTH+1)
    ) wptr_ctrl (
        .clk(wclk),
        .rstn(wrstn),
        .inc(wen),
        .ptr(wptr),
        .ptr_gray(wgray)
    );
    
    // Read pointer control
    ptr_ctrl #(
        .WIDTH(ADDR_WIDTH+1)
    ) rptr_ctrl (
        .clk(rclk),
        .rstn(rrstn),
        .inc(ren),
        .ptr(rptr),
        .ptr_gray(rgray)
    );
    
    // Synchronizers
    sync_cell #(
        .WIDTH(ADDR_WIDTH+1)
    ) w2r_sync (
        .clk(rclk),
        .rstn(rrstn),
        .din(wgray),
        .dout(wgray_sync)
    );
    
    sync_cell #(
        .WIDTH(ADDR_WIDTH+1)
    ) r2w_sync (
        .clk(wclk),
        .rstn(wrstn),
        .din(rgray),
        .dout(rgray_sync)
    );
    
    // Address and flag assignments
    assign waddr = wptr[ADDR_WIDTH-1:0];
    assign raddr = rptr[ADDR_WIDTH-1:0];
    
    // Full detection: MSBs different, other bits same
    assign wfull = (wgray == {~rgray_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                             rgray_sync[ADDR_WIDTH-2:0]});
    
    // Empty detection: pointers equal
    assign rempty = (rgray == wgray_sync);

endmodule

// Dual-port RAM submodule
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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
        if (wenc) mem[waddr] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end
endmodule

// Pointer controller
module ptr_ctrl #(
    parameter WIDTH = 4
)(
    input clk,
    input rstn,
    input inc,
    output reg [WIDTH-1:0] ptr,
    output [WIDTH-1:0] ptr_gray
);
    always @(posedge clk or negedge rstn) begin
        if (!rstn) ptr <= 0;
        else if (inc) ptr <= ptr + 1;
    end
    
    assign ptr_gray = ptr ^ (ptr >> 1);
endmodule

// 2-stage synchronizer
module sync_cell #(
    parameter WIDTH = 4
)(
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
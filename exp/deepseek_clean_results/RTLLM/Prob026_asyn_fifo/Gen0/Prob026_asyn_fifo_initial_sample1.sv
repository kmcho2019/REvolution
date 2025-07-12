module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    // Write interface
    input wire wclk,
    input wire wrstn,
    input wire winc,
    input wire [WIDTH-1:0] wdata,
    output wire wfull,
    
    // Read interface
    input wire rclk,
    input wire rrstn,
    input wire rinc,
    output wire [WIDTH-1:0] rdata,
    output wire rempty
);

    // Calculate address width based on DEPTH
    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Binary and Gray pointers
    reg [ADDR_WIDTH:0] waddr_bin, raddr_bin;
    reg [ADDR_WIDTH:0] wptr, rptr;
    wire [ADDR_WIDTH:0] wptr_gray, rptr_gray;
    
    // Synchronized pointers
    reg [ADDR_WIDTH:0] wptr_syn_rclk, rptr_syn_wclk;
    reg [ADDR_WIDTH:0] wptr_syn_rclk_ff1, wptr_syn_rclk_ff2;
    reg [ADDR_WIDTH:0] rptr_syn_wclk_ff1, rptr_syn_wclk_ff2;
    
    // RAM signals
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];
    
    // Instantiate dual-port RAM
    dual_port_RAM #(
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
    
    // Binary to Gray conversion
    assign wptr_gray = waddr_bin ^ (waddr_bin >> 1);
    assign rptr_gray = raddr_bin ^ (raddr_bin >> 1);
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else begin
            if (wenc) begin
                waddr_bin <= waddr_bin + 1;
            end
            wptr <= wptr_gray;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            if (renc) begin
                raddr_bin <= raddr_bin + 1;
            end
            rptr <= rptr_gray;
        end
    end
    
    // Write pointer synchronization to read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn_rclk_ff1 <= 0;
            wptr_syn_rclk_ff2 <= 0;
            wptr_syn_rclk <= 0;
        end else begin
            wptr_syn_rclk_ff1 <= wptr;
            wptr_syn_rclk_ff2 <= wptr_syn_rclk_ff1;
            wptr_syn_rclk <= wptr_syn_rclk_ff2;
        end
    end
    
    // Read pointer synchronization to write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn_wclk_ff1 <= 0;
            rptr_syn_wclk_ff2 <= 0;
            rptr_syn_wclk <= 0;
        end else begin
            rptr_syn_wclk_ff1 <= rptr;
            rptr_syn_wclk_ff2 <= rptr_syn_wclk_ff1;
            rptr_syn_wclk <= rptr_syn_wclk_ff2;
        end
    end
    
    // Full and empty generation
    assign wfull = (wptr_gray == {~rptr_syn_wclk[ADDR_WIDTH:ADDR_WIDTH-1], 
                                 rptr_syn_wclk[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_syn_rclk);
    
endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire wclk,
    input wire wenc,
    input wire [$clog2(DEPTH)-1:0] waddr,
    input wire [WIDTH-1:0] wdata,
    input wire rclk,
    input wire renc,
    input wire [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
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
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end
    
endmodule
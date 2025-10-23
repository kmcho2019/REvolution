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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);

// Dual-Port RAM Module
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    reg [WIDTH-1:0] ram [DEPTH-1:0];
    reg [WIDTH-1:0] rdata_reg;

    always @(posedge wclk) begin
        if (wenc) begin
            ram[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata_reg <= ram[raddr];
        end
    end

    assign rdata = rdata_reg;
endmodule

// Instantiate Dual-Port RAM
dual_port_ram #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) dual_port_ram_inst (
   .wclk(wclk),
   .wenc(winc & ~wfull),
   .waddr(wptr_gray[ADDR_WIDTH-1:0]),
   .wdata(wdata),
   .rclk(rclk),
   .renc(rinc & ~rempty),
   .raddr(rptr_gray[ADDR_WIDTH-1:0]),
   .rdata(rdata)
);

reg [ADDR_WIDTH:0] wptr_gray;
reg [ADDR_WIDTH:0] rptr_gray;

// Initialize variables
initial begin
    wptr_gray = 0;
    rptr_gray = 0;
    wfull = 0;
    rempty = 1;
end

// Write pointer update
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_gray <= 0;
        wfull <= 0;
    end else if (winc && ~wfull) begin
        wptr_gray <= wptr_gray + 1;
    end
end

// Read pointer update
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_gray <= 0;
        rempty <= 1;
    end else if (rinc && ~rempty) begin
        rptr_gray <= rptr_gray + 1;
    end
end

// Full and empty signal generation
always @(posedge wclk) begin
    if (wptr_gray == {~rptr_gray[ADDR_WIDTH], rptr_gray[ADDR_WIDTH-1:0]}) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr_gray == wptr_gray) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

endmodule
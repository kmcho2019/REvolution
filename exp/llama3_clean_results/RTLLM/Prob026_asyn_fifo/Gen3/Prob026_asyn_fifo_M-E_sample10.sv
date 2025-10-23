module AsyncFIFOFlex #(
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

// Dual-Port RAM (DPRAM) submodule
reg [WIDTH-1:0] dpram [DEPTH-1:0];

// Asynchronous Write Controller (AWC)
reg [ADDR_WIDTH-1:0] waddr;
reg [WIDTH-1:0] wdata_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr <= 0;
        wdata_reg <= 0;
    end else if (winc && ~wfull) begin
        dpram[waddr] <= wdata;
        waddr <= waddr + 1;
    end
end

// Asynchronous Read Controller (ARC)
reg [ADDR_WIDTH-1:0] raddr;
reg [WIDTH-1:0] rdata_reg;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr <= 0;
        rdata_reg <= 0;
    end else if (rinc && ~rempty) begin
        rdata_reg <= dpram[raddr];
        raddr <= raddr + 1;
    end
end

// Clock Domain Crossing (CDC) module
reg [ADDR_WIDTH-1:0] waddr_cdc;
reg [WIDTH-1:0] wdata_cdc;

always @(posedge wclk) begin
    waddr_cdc <= waddr;
    wdata_cdc <= wdata_reg;
end

always @(posedge rclk) begin
    rdata <= rdata_reg;
end

// Full and empty signals
assign wfull = (waddr == DEPTH - 1);
assign rempty = (raddr == 0);

endmodule
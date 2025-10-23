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
  .waddr(wptr_bin[ADDR_WIDTH-1:0]),
  .wdata(wdata),
  .rclk(rclk),
  .renc(rinc & ~rempty),
  .raddr(rptr_bin[ADDR_WIDTH-1:0]),
  .rdata(rdata)
);

reg [ADDR_WIDTH:0] wptr_bin;
reg [ADDR_WIDTH:0] rptr_bin;

// Gray Code Conversion
wire [ADDR_WIDTH:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
wire [ADDR_WIDTH:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

// Write Pointer Update
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc && ~wfull) begin
        wptr_bin <= wptr_bin + 1;
    end
end

// Read Pointer Update
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc && ~rempty) begin
        rptr_bin <= rptr_bin + 1;
    end
end

// Full and Empty Signal Generation
assign wfull = (wptr_gray == {~rptr_gray[ADDR_WIDTH], rptr_gray[ADDR_WIDTH-1:0]});
assign rempty = (rptr_gray == wptr_gray);

endmodule
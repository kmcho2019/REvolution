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

// FIFO Controller
module fifo_controller #(
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    output reg wfull,
    output reg rempty,
    output reg [ADDR_WIDTH-1:0] waddr,
    output reg [ADDR_WIDTH-1:0] raddr
);
    reg [ADDR_WIDTH-1:0] wptr;
    reg [ADDR_WIDTH-1:0] rptr;

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr <= 0;
            wfull <= 0;
        end else if (winc && ~wfull) begin
            wptr <= (wptr + 1) % DEPTH;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr <= 0;
            rempty <= 1;
        end else if (rinc && ~rempty) begin
            rptr <= (rptr + 1) % DEPTH;
        end
    end

    assign waddr = wptr;
    assign raddr = rptr;

    always @(posedge wclk) begin
        if (wptr == (rptr + 1) % DEPTH) begin
            wfull <= 1;
        end else begin
            wfull <= 0;
        end
    end

    always @(posedge rclk) begin
        if (rptr == wptr) begin
            rempty <= 1;
        end else begin
            rempty <= 0;
        end
    end
endmodule

// Clock Domain Crossing (CDC) Module
module cdc #(
    parameter WIDTH = 8
)(
    input wclk,
    input rclk,
    input [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata
);
    reg [WIDTH-1:0] temp1;
    reg [WIDTH-1:0] temp2;

    always @(posedge wclk) begin
        temp1 <= wdata;
    end

    always @(posedge rclk) begin
        temp2 <= temp1;
        rdata <= temp2;
    end
endmodule

// Instantiate Dual-Port RAM
dual_port_ram #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) dual_port_ram_inst (
    .wclk(wclk),
    .wenc(winc & ~wfull),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc & ~rempty),
    .raddr(raddr),
    .rdata(rdata)
);

// Instantiate FIFO Controller
fifo_controller #(
    .DEPTH(DEPTH)
) fifo_controller_inst (
    .wclk(wclk),
    .rclk(rclk),
    .wrstn(wrstn),
    .rrstn(rrstn),
    .winc(winc),
    .rinc(rinc),
    .wfull(wfull),
    .rempty(rempty),
    .waddr(waddr),
    .raddr(raddr)
);

// Instantiate Clock Domain Crossing (CDC) Module
cdc #(
    .WIDTH(WIDTH)
) cdc_inst (
    .wclk(wclk),
    .rclk(rclk),
    .wdata(wdata),
    .rdata(rdata)
);

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic           wclk,
    input  logic           rclk,
    input  logic           wrstn,
    input  logic           rrstn,
    input  logic           winc,
    input  logic           rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic           wfull,
    output logic           rempty,
    output logic [WIDTH-1:0] rdata
);

logic [WIDTH-1:0] ram_wdata;
logic [WIDTH-1:0] ram_rdata;
logic            wenc;
logic            renc;

logic [$clog2(DEPTH)-1:0] waddr;
logic [$clog2(DEPTH)-1:0] raddr;

logic [$clog2(DEPTH)-1:0] waddr_bin;
logic [$clog2(DEPTH)-1:0] raddr_bin;

logic [$clog2(DEPTH)-1:0] wptr;
logic [$clog2(DEPTH)-1:0] rptr;
logic [$clog2(DEPTH)-1:0] wptr_syn;
logic [$clog2(DEPTH)-1:0] rptr_syn;

// Instantiate dual-port RAM
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) u_ram (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(ram_rdata)
);

// Write pointer logic
always_ff @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer logic
always_ff @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Convert binary pointers to Gray code
always_comb begin
    wptr = waddr_bin ^ (waddr_bin >> 1);
    rptr = raddr_bin ^ (raddr_bin >> 1);
end

// Synchronize read pointer to write clock domain
always_ff @(posedge wclk) begin
    rptr_syn <= rptr;
end

// Synchronize write pointer to read clock domain
always_ff @(posedge rclk) begin
    wptr_syn <= wptr;
end

// Determine empty and full conditions
always_comb begin
    wfull = (wptr[$clog2(DEPTH)-1] == ~rptr_syn[$clog2(DEPTH)-1]) && (wptr[$clog2(DEPTH)-2:0] == rptr_syn[$clog2(DEPTH)-2:0]);
    rempty = (wptr == rptr);
end

// Generate RAM addresses
always_comb begin
    waddr = waddr_bin[$clog2(DEPTH)-1:1];
    raddr = raddr_bin[$clog2(DEPTH)-1:1];
end

// Generate enable signals for RAM
always_comb begin
    wenc = winc;
    renc = rinc;
end

// Assign output
assign rdata = ram_rdata;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic           wclk,
    input  logic           wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0] wdata,
    input  logic           rclk,
    input  logic           renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);

logic [WIDTH-1:0] ram_mem [DEPTH-1:0];

// Write logic
always_ff @(posedge wclk) begin
    if (wenc) begin
        ram_mem[waddr] <= wdata;
    end
end

// Read logic
always_ff @(posedge rclk) begin
    if (renc) begin
        rdata <= ram_mem[raddr];
    end else begin
        rdata <= 'x;
    end
end

endmodule
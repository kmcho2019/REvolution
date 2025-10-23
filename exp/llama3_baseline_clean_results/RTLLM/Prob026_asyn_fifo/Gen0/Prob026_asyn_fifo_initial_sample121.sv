module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wire                wclk,        // Write clock signal
    input  wire                rclk,        // Read clock signal
    input  wire                wrstn,       // Write reset signal
    input  wire                rrstn,       // Read reset signal
    input  wire                winc,        // Write increment signal
    input  wire                rinc,        // Read increment signal
    input  wire [WIDTH-1:0]    wdata,       // Write data input
    output wire                wfull,       // Write full signal
    output wire                rempty,      // Read empty signal
    output wire [WIDTH-1:0]    rdata        // Read data output
);

reg [WIDTH-1:0] ram_mem [0:DEPTH-1];  // Dual-port RAM memory

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wire                wclk,        // Write clock signal
    input  wire                wenc,        // Write enable signal
    input  wire [$clog2(DEPTH)-1:0] waddr,  // Write address
    input  wire [WIDTH-1:0]    wdata,       // Write data input
    input  wire                rclk,        // Read clock signal
    input  wire                renc,        // Read enable signal
    input  wire [$clog2(DEPTH)-1:0] raddr,  // Read address
    output reg [WIDTH-1:0]     rdata        // Read data output
);
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];  // RAM memory

    always @(posedge wclk) begin
        if (wenc) begin
            ram_mem[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= ram_mem[raddr];
        end
    end
endmodule

wire wenc, renc;
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [WIDTH-1:0] wptr, rptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_bin, rptr_bin;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
reg [WIDTH-1:0] rptr;

// Write pointer increment and Gray code conversion
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
    wptr_bin <= waddr_bin;
    wptr <= (wptr_bin >> 1) ^ wptr_bin;
end

// Read pointer increment and Gray code conversion
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
    rptr_bin <= raddr_bin;
    rptr <= (rptr_bin >> 1) ^ rptr_bin;
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn_d1, rptr_syn_d2;
always @(posedge wclk) begin
    rptr_syn_d1 <= rptr;
    rptr_syn_d2 <= rptr_syn_d1;
    rptr_syn <= rptr_syn_d2;
end

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn_d1, wptr_syn_d2;
always @(posedge rclk) begin
    wptr_syn_d1 <= wptr_bin;
    wptr_syn_d2 <= wptr_syn_d1;
    wptr_buff <= wptr_syn_d2;
end

// Empty and full signal generation
assign wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr);

// Input and output connections
assign wenc = winc;
assign renc = rinc;
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) dual_port_ram_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin[$clog2(DEPTH)-2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin[$clog2(DEPTH)-2:0]),
    .rdata(rdata)
);

endmodule
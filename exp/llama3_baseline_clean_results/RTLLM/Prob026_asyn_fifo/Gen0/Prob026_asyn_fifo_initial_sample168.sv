module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wclk,  // Write clock signal
    input  rclk,  // Read clock signal
    input  wrstn, // Write reset signal
    input  rrstn, // Read reset signal
    input  winc,  // Write increment signal
    input  rinc,  // Read increment signal
    input  [WIDTH-1:0] wdata, // Write data input
    output reg wfull, // Write full signal
    output reg rempty, // Read empty signal
    output reg [WIDTH-1:0] rdata // Read data output
);

// Define the number of bits required to represent the depth of the FIFO
localparam ADDR_WIDTH = $clog2(DEPTH);

// Define the dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = WIDTH,
    parameter DEPTH = DEPTH
) (
    input  wclk,  // Write clock signal
    input  wenc,  // Write enable signal
    input  [ADDR_WIDTH-1:0] waddr, // Write address
    input  [WIDTH-1:0] wdata, // Write data
    input  rclk,  // Read clock signal
    input  renc,  // Read enable signal
    input  [ADDR_WIDTH-1:0] raddr, // Read address
    output reg [WIDTH-1:0] rdata // Read data
);
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0]; // RAM memory

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        rdata <= RAM_MEM[raddr];
    end
endmodule

// Instantiate the dual-port RAM module
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dual_port_ram_inst (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
);

// Define the write and read pointers
reg [ADDR_WIDTH-1:0] waddr_bin = 0;
reg [ADDR_WIDTH-1:0] raddr_bin = 0;

// Define the Gray code conversion logic
reg [ADDR_WIDTH-1:0] wptr, rptr;
reg [ADDR_WIDTH-1:0] wptr_buff, rptr_buff;

// Define the full and empty detection logic
reg wfull_int = 0;
reg rempty_int = 0;

// Write pointer increment logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-2]^waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-3]^waddr_bin[ADDR_WIDTH-2], waddr_bin[ADDR_WIDTH-4]^waddr_bin[ADDR_WIDTH-3]};
    end
end

// Read pointer increment logic
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-2]^raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-3]^raddr_bin[ADDR_WIDTH-2], raddr_bin[ADDR_WIDTH-4]^raddr_bin[ADDR_WIDTH-3]};
    end
end

// Write pointer buffer logic
always @(posedge wclk) begin
    wptr_buff <= wptr;
end

// Read pointer buffer logic
always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// Full detection logic
always @(posedge wclk) begin
    if (wptr_buff == {~rptr[ADDR_WIDTH-1], rptr[ADDR_WIDTH-2], rptr[ADDR_WIDTH-3], rptr[ADDR_WIDTH-4]}) begin
        wfull_int <= 1'b1;
    end else begin
        wfull_int <= 1'b0;
    end
end

// Empty detection logic
always @(posedge rclk) begin
    if (rptr == wptr_buff) begin
        rempty_int <= 1'b1;
    end else begin
        rempty_int <= 1'b0;
    end
end

// Assign the full and empty signals
assign wfull = wfull_int;
assign rempty = rempty_int;

// Assign the read and write enable signals
reg wen, ren;
assign wen = winc;
assign ren = rinc;

// Assign the write and read addresses
assign waddr = wptr[ADDR_WIDTH-2:0];
assign raddr = rptr[ADDR_WIDTH-2:0];

endmodule
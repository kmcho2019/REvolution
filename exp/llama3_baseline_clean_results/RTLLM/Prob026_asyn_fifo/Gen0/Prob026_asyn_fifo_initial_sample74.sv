module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic        wclk,
    input  logic        rstn,
    input  logic        rrstn,
    input  logic        winc,
    input  logic        rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic        wfull,
    output logic        rempty,
    output logic [WIDTH-1:0] rdata
);

// Define the dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic        wclk,
    input  logic        wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0] wdata,
    input  logic        rclk,
    input  logic        renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);
    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    assign rdata = RAM_MEM[raddr];
endmodule

// Define the Gray code conversion function
function logic [$clog2(DEPTH)-1:0] bin_to_gray;
    input logic [$clog2(DEPTH)-1:0] bin;
    logic [$clog2(DEPTH)-1:0] gray;
    for (int i = 0; i < $clog2(DEPTH); i++) begin
        gray[i] = bin[i] ^ (i > 0? bin[i-1] : 1'b0);
    end
    return gray;
endfunction

// Define the binary code conversion function
function logic [$clog2(DEPTH)-1:0] gray_to_bin;
    input logic [$clog2(DEPTH)-1:0] gray;
    logic [$clog2(DEPTH)-1:0] bin;
    for (int i = 0; i < $clog2(DEPTH); i++) begin
        bin[i] = gray[i] ^ (i > 0? bin[i-1] : 1'b0);
    end
    return bin;
endfunction

// Define the write pointer register
logic [$clog2(DEPTH)-1:0] waddr_bin;
always @(posedge wclk or negedge rstn) begin
    if (~rstn) begin
        waddr_bin <= '0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1'b1;
    end
end

// Define the read pointer register
logic [$clog2(DEPTH)-1:0] raddr_bin;
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= '0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1'b1;
    end
end

// Define the write pointer buffer
logic [$clog2(DEPTH)-1:0] wptr_buff;
always @(posedge wclk or negedge rstn) begin
    if (~rstn) begin
        wptr_buff <= '0;
    end else begin
        wptr_buff <= waddr_bin;
    end
end

// Define the read pointer buffer
logic [$clog2(DEPTH)-1:0] rptr_buff;
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_buff <= '0;
    end else begin
        rptr_buff <= raddr_bin;
    end
end

// Define the write pointer synchronizer
logic [$clog2(DEPTH)-1:0] wptr_syn;
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_syn <= '0;
    end else begin
        wptr_syn <= wptr_buff;
    end
end

// Define the read pointer synchronizer
logic [$clog2(DEPTH)-1:0] rptr_syn;
always @(posedge wclk or negedge rstn) begin
    if (~rstn) begin
        rptr_syn <= '0;
    end else begin
        rptr_syn <= rptr_buff;
    end
end

// Define the Gray code conversion for write pointer
logic [$clog2(DEPTH)-1:0] wptr;
assign wptr = bin_to_gray(waddr_bin);

// Define the Gray code conversion for read pointer
logic [$clog2(DEPTH)-1:0] rptr;
assign rptr = bin_to_gray(raddr_bin);

// Define the full signal generation
assign wfull = (wptr[$clog2(DEPTH)-1]!= rptr_syn[$clog2(DEPTH)-1]) && (wptr[$clog2(DEPTH)-2:$clog2(DEPTH)-2] == rptr_syn[$clog2(DEPTH)-2:$clog2(DEPTH)-2]) && (wptr[$clog2(DEPTH)-3:0] == rptr_syn[$clog2(DEPTH)-3:0]);

// Define the empty signal generation
assign rempty = (wptr == rptr_syn);

// Define the write enable signal
logic wenc;
assign wenc = winc &&!wfull;

// Define the read enable signal
logic renc;
assign renc = rinc &&!rempty;

// Instantiate the dual-port RAM module
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) ram_inst (
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
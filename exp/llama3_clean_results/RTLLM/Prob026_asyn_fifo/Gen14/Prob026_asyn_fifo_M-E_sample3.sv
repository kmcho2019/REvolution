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

// Dual-Port RAM
module dual_port_RAM #(
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
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end
endmodule

// Binary to Gray Code Converter
function [ADDR_WIDTH-1:0] bin_to_gray;
    input [ADDR_WIDTH-1:0] bin;
    begin
        bin_to_gray = (bin >> 1) ^ bin;
    end
endfunction

// Gray Code Comparator
function [1:0] compare_gray;
    input [ADDR_WIDTH-1:0] gray1, gray2;
    begin
        compare_gray = (gray1 == gray2) ? 2'b01 : (gray1 == (~gray2[ADDR_WIDTH-1] ^ gray2) ? 2'b10 : 2'b00);
    end
endfunction

// Write and Read Controllers
reg [ADDR_WIDTH-1:0] wptr, rptr;
reg [ADDR_WIDTH-1:0] wptr_gray, rptr_gray;
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= wptr + 1;
    end
end
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= rptr + 1;
    end
end

// Clock Domain Crossing (CDC) Module
reg [ADDR_WIDTH-1:0] wptr_sync1, wptr_sync2;
always @(posedge rclk) begin
    wptr_sync1 <= wptr;
    wptr_sync2 <= wptr_sync1;
end

// Main FIFO Logic
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
    .wclk(wclk),
    .wenc(winc),
    .waddr(wptr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr),
    .rdata(rdata)
);

always @(posedge wclk) begin
    wptr_gray <= bin_to_gray(wptr);
end
always @(posedge rclk) begin
    rptr_gray <= bin_to_gray(rptr);
end

assign wfull = (compare_gray(wptr_gray, bin_to_gray((rptr + 1) % DEPTH)) == 2'b10);
assign rempty = (compare_gray(wptr_gray, rptr_gray) == 2'b01);

endmodule
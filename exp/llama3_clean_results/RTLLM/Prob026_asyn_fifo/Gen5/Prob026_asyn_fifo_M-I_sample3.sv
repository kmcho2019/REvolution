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
localparam GRAY_WIDTH = ADDR_WIDTH + 1;

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] write_pointer;
reg [ADDR_WIDTH-1:0] read_pointer;
reg [GRAY_WIDTH-1:0] write_pointer_gray;
reg [GRAY_WIDTH-1:0] read_pointer_gray;
reg [GRAY_WIDTH-1:0] write_pointer_gray_sync;
reg [GRAY_WIDTH-1:0] read_pointer_gray_sync;

// Convert binary to Gray code
function [GRAY_WIDTH-1:0] bin_to_gray;
    input [ADDR_WIDTH-1:0] bin;
    reg [GRAY_WIDTH-1:0] gray;
    begin
        gray = {1'b0, bin} ^ ({1'b0, bin} >> 1);
        bin_to_gray = gray;
    end
endfunction

// Write pointer increment and gray code conversion
always @(posedge wclk) begin
    if (~wrstn) begin
        write_pointer <= 0;
    end else if (winc && ~wfull) begin
        write_pointer <= (write_pointer + 1) % DEPTH;
    end
    write_pointer_gray <= bin_to_gray(write_pointer);
end

// Read pointer increment and gray code conversion
always @(posedge rclk) begin
    if (~rrstn) begin
        read_pointer <= 0;
    end else if (rinc && ~rempty) begin
        read_pointer <= (read_pointer + 1) % DEPTH;
    end
    read_pointer_gray <= bin_to_gray(read_pointer);
end

// Synchronize write pointer to read clock domain
always @(posedge rclk) begin
    write_pointer_gray_sync <= write_pointer_gray;
end

// Synchronize read pointer to write clock domain
always @(posedge wclk) begin
    read_pointer_gray_sync <= read_pointer_gray;
end

// Write operation
always @(posedge wclk) begin
    if (winc && ~wfull) begin
        RAM_MEM[write_pointer] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (rinc && ~rempty) begin
        rdata <= RAM_MEM[read_pointer];
    end
end

// Full and empty signals
assign wfull = (write_pointer_gray_sync[GRAY_WIDTH-1] != read_pointer_gray[GRAY_WIDTH-1]) && (write_pointer_gray_sync[GRAY_WIDTH-2:0] == read_pointer_gray[GRAY_WIDTH-2:0]);
assign rempty = (write_pointer_gray_sync == read_pointer_gray);

endmodule
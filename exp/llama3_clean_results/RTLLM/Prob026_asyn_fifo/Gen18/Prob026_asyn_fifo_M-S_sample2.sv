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

reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [2:0] wgray;
reg [2:0] rgray;

// Write Controller
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= wptr + 1;
        if (wptr == DEPTH - 1) begin
            wptr <= 0;
        end
    end
end

// Read Controller
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= rptr + 1;
        if (rptr == DEPTH - 1) begin
            rptr <= 0;
        end
    end
end

// Gray Code Conversion
always @(posedge wclk) begin
    wgray[2] <= wptr[2] ^ wptr[1];
    wgray[1] <= wptr[1] ^ wptr[0];
    wgray[0] <= wptr[0];
end

always @(posedge rclk) begin
    rgray[2] <= rptr[2] ^ rptr[1];
    rgray[1] <= rptr[1] ^ rptr[0];
    rgray[0] <= rptr[0];
end

// RAM Write
always @(posedge wclk) begin
    if (winc) begin
        ram[wptr] <= wdata;
    end
end

// RAM Read
always @(posedge rclk) begin
    rdata <= ram[rptr];
end

// Full and Empty Signal Generation
always @(posedge wclk) begin
    if (wptr == rptr + 1) begin
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
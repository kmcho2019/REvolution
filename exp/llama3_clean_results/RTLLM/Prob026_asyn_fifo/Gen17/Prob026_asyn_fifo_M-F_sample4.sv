// Optimized Gray code conversion
// Using a lookup table for Gray code conversion
reg [3:0] wptr_gray;
reg [3:0] rptr_gray;

always @(posedge wclk) begin
    case (wptr_bin[3:0])
        4'b0000: wptr_gray = 4'b0000;
        4'b0001: wptr_gray = 4'b0001;
        4'b0010: wptr_gray = 4'b0011;
        4'b0011: wptr_gray = 4'b0010;
        4'b0100: wptr_gray = 4'b0110;
        4'b0101: wptr_gray = 4'b0111;
        4'b0110: wptr_gray = 4'b0101;
        4'b0111: wptr_gray = 4'b0100;
        4'b1000: wptr_gray = 4'b1100;
        4'b1001: wptr_gray = 4'b1101;
        4'b1010: wptr_gray = 4'b1111;
        4'b1011: wptr_gray = 4'b1110;
        4'b1100: wptr_gray = 4'b1010;
        4'b1101: wptr_gray = 4'b1011;
        4'b1110: wptr_gray = 4'b1001;
        4'b1111: wptr_gray = 4'b1000;
    endcase
end

always @(posedge rclk) begin
    case (rptr_bin[3:0])
        4'b0000: rptr_gray = 4'b0000;
        4'b0001: rptr_gray = 4'b0001;
        4'b0010: rptr_gray = 4'b0011;
        4'b0011: rptr_gray = 4'b0010;
        4'b0100: rptr_gray = 4'b0110;
        4'b0101: rptr_gray = 4'b0111;
        4'b0110: rptr_gray = 4'b0101;
        4'b0111: rptr_gray = 4'b0100;
        4'b1000: rptr_gray = 4'b1100;
        4'b1001: rptr_gray = 4'b1101;
        4'b1010: rptr_gray = 4'b1111;
        4'b1011: rptr_gray = 4'b1110;
        4'b1100: rptr_gray = 4'b1010;
        4'b1101: rptr_gray = 4'b1011;
        4'b1110: rptr_gray = 4'b1001;
        4'b1111: rptr_gray = 4'b1000;
    endcase
end

// Improved clock gating technique
reg wclk_gated;
reg rclk_gated;

always @(posedge wclk) begin
    if (~wrstn) begin
        wclk_gated <= 0;
    end else if (winc) begin
        wclk_gated <= 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rclk_gated <= 0;
    end else if (rinc) begin
        rclk_gated <= 1;
    end
end

// Optimized dual-port RAM implementation
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,
    input  logic             wenc,
    input  logic [WIDTH-1:0] wdata,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic             rclk,
    input  logic             renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);

    logic [WIDTH-1:0] ram [DEPTH-1:0];

    always @(posedge wclk) begin
        if (wenc) begin
            ram[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= ram[raddr];
        end
    end

endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,
    input  logic             wrstn,
    input  logic             rclk,
    input  logic             rrstn,
    input  logic             winc,
    input  logic             rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic             wfull,
    output logic             rempty,
    output logic [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    logic [PTR_WIDTH-1:0] wptr_bin;
    logic [PTR_WIDTH-1:0] rptr_bin;

    logic [PTR_WIDTH-1:0] wptr_gray;
    logic [PTR_WIDTH-1:0] rptr_gray;

    logic [PTR_WIDTH-1:0] wptr_gray_sync;
    logic [PTR_WIDTH-1:0] rptr_gray_sync;

    logic wren;
    logic rden;

    assign wren = winc & ~wfull;
    assign rden = rinc & ~rempty;

    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end else if (winc) begin
            wptr_bin <= (wptr_bin + 1) % DEPTH;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= (rptr_bin + 1) % DEPTH;
        end
    end

    always @(posedge rclk) begin
        wptr_gray_sync <= wptr_gray;
    end

    always @(posedge wclk) begin
        rptr_gray_sync <= rptr_gray;
    end

    assign wfull = (wptr_gray == (rptr_gray_sync + 1) % (1 << PTR_WIDTH));
    assign rempty = (rptr_gray == wptr_gray);

    dual_port_ram #(.WIDTH(WIDTH),.DEPTH(DEPTH)) ram_instance (
      .wclk(wclk),
      .wenc(wren),
      .wdata(wdata),
      .waddr(wptr_bin),
      .rclk(rclk),
      .renc(rden),
      .raddr(rptr_bin),
      .rdata(rdata)
    );

endmodule
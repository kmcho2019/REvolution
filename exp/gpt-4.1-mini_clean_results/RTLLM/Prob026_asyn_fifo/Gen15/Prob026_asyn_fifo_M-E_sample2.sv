`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // Active low reset for write domain
    input                   rrstn,   // Active low reset for read domain
    input                   winc,    // Write increment (write enable)
    input                   rinc,    // Read increment (read enable)
    input  [WIDTH-1:0]      wdata,   // Data input to write
    output                  wfull,   // FIFO full flag (write domain)
    output                  rempty,  // FIFO empty flag (read domain)
    output [WIDTH-1:0]      rdata    // Data output from read
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // Gray pointer width (extra bit)

    // Write pointer controller
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [ADDR_WIDTH-1:0] waddr_bin;
    wire wptr_inc_req;
    assign wptr_inc_req = (winc & ~wfull);

    write_pointer #(
        .PTR_WIDTH(PTR_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) write_pointer_inst (
        .clk(wclk),
        .rstn(wrstn),
        .inc(wptr_inc_req),
        .ptr_gray(wptr_gray),
        .ptr_bin(waddr_bin)
    );

    // Read pointer controller
    wire [PTR_WIDTH-1:0] rptr_gray;
    wire [ADDR_WIDTH-1:0] raddr_bin;
    wire rptr_inc_req;
    assign rptr_inc_req = (rinc & ~rempty);

    read_pointer #(
        .PTR_WIDTH(PTR_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) read_pointer_inst (
        .clk(rclk),
        .rstn(rrstn),
        .inc(rptr_inc_req),
        .ptr_gray(rptr_gray),
        .ptr_bin(raddr_bin)
    );

    // Synchronize read pointer to write clock domain for full detection
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    gray_sync #(.WIDTH(PTR_WIDTH)) rptr_sync_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .in_gray(rptr_gray),
        .out_gray(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer to read clock domain for empty detection
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;
    gray_sync #(.WIDTH(PTR_WIDTH)) wptr_sync_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .in_gray(wptr_gray),
        .out_gray(wptr_gray_sync_rclk)
    );

    // Full detection (write clock domain)
    // Full when write pointer equals read pointer with MSB and second MSB inverted
    assign wfull = (wptr_gray == { ~rptr_gray_sync_wclk[PTR_WIDTH-1],
                                  ~rptr_gray_sync_wclk[PTR_WIDTH-2],
                                   rptr_gray_sync_wclk[PTR_WIDTH-3:0] });

    // Empty detection (read clock domain)
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Write enable for RAM (write clock domain)
    wire wenc = wptr_inc_req; // write only when incrementing (valid write & not full)

    // Read enable for RAM (read clock domain)
    wire renc = rptr_inc_req; // read only when incrementing (valid read & not empty)

    // Data read from RAM
    wire [WIDTH-1:0] ram_rdata;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr_bin),
        .rdata(ram_rdata)
    );

    // Output registered on read clock domain for stability
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (renc)
            rdata_reg <= ram_rdata;
    end

    assign rdata = rdata_reg;

endmodule

// Write pointer controller - Gray-coded counter + binary address output
module write_pointer #(
    parameter PTR_WIDTH = 5,       // Depth 16 means PTR_WIDTH=5 (ADDR_WIDTH+1)
    parameter ADDR_WIDTH = 4
)(
    input                   clk,
    input                   rstn,
    input                   inc,
    output reg [PTR_WIDTH-1:0] ptr_gray,
    output wire [ADDR_WIDTH-1:0] ptr_bin
);
    // Internal binary counter
    reg [PTR_WIDTH-1:0] ptr_bin_int;

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            ptr_bin_int <= 0;
        else if (inc)
            ptr_bin_int <= ptr_bin_int + 1'b1;
    end

    // Convert binary pointer to Gray code
    always @(*) begin
        ptr_gray = (ptr_bin_int >> 1) ^ ptr_bin_int;
    end

    // Provide binary address for RAM (lower bits)
    assign ptr_bin = ptr_bin_int[ADDR_WIDTH-1:0];

endmodule

// Read pointer controller - Gray-coded counter + binary address output
module read_pointer #(
    parameter PTR_WIDTH = 5,
    parameter ADDR_WIDTH = 4
)(
    input                   clk,
    input                   rstn,
    input                   inc,
    output reg [PTR_WIDTH-1:0] ptr_gray,
    output wire [ADDR_WIDTH-1:0] ptr_bin
);
    reg [PTR_WIDTH-1:0] ptr_bin_int;

    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            ptr_bin_int <= 0;
        else if (inc)
            ptr_bin_int <= ptr_bin_int + 1'b1;
    end

    always @(*) begin
        ptr_gray = (ptr_bin_int >> 1) ^ ptr_bin_int;
    end

    assign ptr_bin = ptr_bin_int[ADDR_WIDTH-1:0];

endmodule

// Gray code 2-stage synchronizer for clock domain crossing
module gray_sync #(
    parameter WIDTH = 5
)(
    input                   clk,
    input                   rstn,
    input  [WIDTH-1:0]      in_gray,
    output reg [WIDTH-1:0]  out_gray
);
    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= {WIDTH{1'b0}};
            out_gray <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= in_gray;
            out_gray <= sync_ff1;
        end
    end
endmodule

// Dual-port RAM with separate clocks and enables
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end
endmodule
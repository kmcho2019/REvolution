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

    logic wren;
    logic rden;

    assign wren = winc & ~wfull;
    assign rden = rinc & ~rempty;

    assign wptr_gray = {wptr_bin[PTR_WIDTH-1] ^ wptr_bin[PTR_WIDTH-2], wptr_bin[PTR_WIDTH-2:0]};
    assign rptr_gray = {rptr_bin[PTR_WIDTH-1] ^ rptr_bin[PTR_WIDTH-2], rptr_bin[PTR_WIDTH-2:0]};

    assign wfull = (wptr_gray == {rptr_gray[PTR_WIDTH-1] ^ 1, rptr_gray[PTR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_gray);

    always @(posedge wclk or negedge wrstn or posedge rclk or negedge rrstn) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end else if (winc) begin
            wptr_bin <= wptr_bin + 1;
        end

        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

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
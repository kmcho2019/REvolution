module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  logic            wclk,
    input  logic            rclk,
    input  logic            wrstn,
    input  logic            rrstn,
    input  logic            winc,
    input  logic            rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic            wfull,
    output logic            rempty,
    output logic [WIDTH-1:0] rdata
);

// Dual-port RAM module (unchanged for simplicity)
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  logic            wclk,
    input  logic            wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0] wdata,
    input  logic            rclk,
    input  logic            renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);
    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always_ff @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always_ff @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end
endmodule

// Instantiate dual-port RAM module
dual_port_RAM #(
   .DEPTH(DEPTH),
   .WIDTH(WIDTH)
) dual_port_RAM_inst (
   .wclk(wclk),
   .wenc(winc),
   .waddr(write_ptr[$clog2(DEPTH)-1:0]),
   .wdata(wdata),
   .rclk(rclk),
   .renc(rinc),
   .raddr(read_ptr[$clog2(DEPTH)-1:0]),
   .rdata(rdata)
);

// Write and read pointers
logic [$clog2(DEPTH)-1:0] write_ptr;
logic [$clog2(DEPTH)-1:0] read_ptr;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        write_ptr <= 0;
    end else if (winc) begin
        write_ptr <= write_ptr + 1;
    end
end

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        read_ptr <= 0;
    end else if (rinc) begin
        read_ptr <= read_ptr + 1;
    end
end

// Synchronize write pointer to read clock domain
logic [$clog2(DEPTH)-1:0] write_ptr_syn;

always_ff @(posedge rclk) begin
    write_ptr_syn <= write_ptr;
end

// Full and empty signals using a straightforward approach
assign wfull = (write_ptr == {~read_ptr[$clog2(DEPTH)-1], read_ptr[$clog2(DEPTH)-2:0]});
assign rempty = (read_ptr == write_ptr);

endmodule
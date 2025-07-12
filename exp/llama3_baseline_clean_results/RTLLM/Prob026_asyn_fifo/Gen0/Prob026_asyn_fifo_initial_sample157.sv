module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input  logic             wclk,  // Write clock signal
    input  logic             rclk,  // Read clock signal
    input  logic             wrstn, // Write reset signal
    input  logic             rrstn, // Read reset signal
    input  logic             winc,  // Write increment signal
    input  logic             rinc,  // Read increment signal
    input  logic [WIDTH-1:0] wdata, // Write data input
    output logic             wfull, // Write full signal
    output logic             rempty, // Read empty signal
    output logic [WIDTH-1:0] rdata  // Read data output
);

    // Calculate the number of bits required for the pointers
    localparam PTR_WIDTH = $clog2(DEPTH);

    // Dual-port RAM module
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin),
        .rdata(rdata_ram)
    );

    // Write and read pointer registers
    logic [PTR_WIDTH-1:0] waddr_bin, raddr_bin;
    logic [PTR_WIDTH-1:0] wptr_bin, rptr_bin;

    // Write and read pointer buffers
    logic [PTR_WIDTH-1:0] wptr_buff, rptr_buff;

    // Write and read enable signals
    logic wen, ren;

    // Synchronized read pointer
    logic [PTR_WIDTH-1:0] rptr_syn;

    // Initialize write and read pointers
    initial begin
        waddr_bin = '0;
        raddr_bin = '0;
        wptr_bin = '0;
        rptr_bin = '0;
        wptr_buff = '0;
        rptr_buff = '0;
    end

    // Write pointer update
    always_ff @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= '0;
            wptr_bin <= '0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_bin <= waddr_bin + 1;
        end
    end

    // Read pointer update
    always_ff @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= '0;
            rptr_bin <= '0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr_bin <= raddr_bin + 1;
        end
    end

    // Write pointer buffer update
    always_ff @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_buff <= '0;
        end else begin
            wptr_buff <= wptr_bin;
        end
    end

    // Read pointer buffer update
    always_ff @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_buff <= '0;
        end else begin
            rptr_buff <= rptr_bin;
        end
    end

    // Gray code conversion
    logic [PTR_WIDTH-1:0] wptr, rptr;
    always_comb begin
        wptr = wptr_bin ^ (wptr_bin >> 1);
        rptr = rptr_bin ^ (rptr_bin >> 1);
    end

    // Synchronize read pointer
    logic [PTR_WIDTH-1:0] rptr_syn_reg1, rptr_syn_reg2;
    always_ff @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_syn_reg1 <= '0;
            rptr_syn_reg2 <= '0;
        end else begin
            rptr_syn_reg1 <= rptr;
            rptr_syn_reg2 <= rptr_syn_reg1;
        end
    end
    assign rptr_syn = rptr_syn_reg2;

    // Full and empty signal generation
    always_comb begin
        if (wptr == ({~rptr_syn[PTR_WIDTH-1], rptr_syn[PTR_WIDTH-2:0]})) begin
            wfull = 1'b1;
        end else begin
            wfull = 1'b0;
        end

        if (rptr == wptr) begin
            rempty = 1'b1;
        end else begin
            rempty = 1'b0;
        end
    end

    // Write enable signal
    always_comb begin
        if (~wfull && winc) begin
            wen = 1'b1;
        end else begin
            wen = 1'b0;
        end
    end

    // Read enable signal
    always_comb begin
        if (~rempty && rinc) begin
            ren = 1'b1;
        end else begin
            ren = 1'b0;
        end
    end

    // Assign read data
    assign rdata = rdata_ram;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input  logic             wclk,  // Write clock signal
    input  logic             wenc,  // Write enable signal
    input  logic [3:0]       waddr, // Write address
    input  logic [WIDTH-1:0] wdata, // Write data input
    input  logic             rclk,  // Read clock signal
    input  logic             renc,  // Read enable signal
    input  logic [3:0]       raddr, // Read address
    output logic [WIDTH-1:0] rdata  // Read data output
);

    // RAM memory
    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Initialize RAM memory
    initial begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM_MEM[i] = '0;
        end
    end

    // Write operation
    always_ff @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always_comb begin
        if (renc) begin
            rdata = RAM_MEM[raddr];
        end else begin
            rdata = '0;
        end
    end

endmodule
module asyn_fifo #
    (parameter DEPTH = 16,
     parameter WIDTH = 8)
    (input wclk, 
     input rclk, 
     input wrstn, 
     input rrstn, 
     input winc, 
     input rinc, 
     input [WIDTH-1:0] wdata, 
     output wfull, 
     output rempty, 
     output [WIDTH-1:0] rdata);

    // Dual-port RAM
    wire wenc, renc;
    wire [$clog2(DEPTH)-1:0] waddr, raddr;
    wire [WIDTH-1:0] rdata_out;

    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH))
    dual_port_RAM_inst (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata_out)
    );

    assign rdata = rdata_out;

    // Write Pointer
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [2:0] wptr;  // 3-bit Gray code
    reg [2:0] wptr_buff;  // buffer for wptr

    // Read Pointer
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [2:0] rptr;  // 3-bit Gray code
    reg [2:0] rptr_syn;  // synchronized rptr
    reg [2:0] rptr_buff;  // buffer for rptr

    // Initialize write and read pointers
    initial begin
        waddr_bin = 0;
        wptr = 0;
        wptr_buff = 0;
        raddr_bin = 0;
        rptr = 0;
        rptr_syn = 0;
        rptr_buff = 0;
    end

    // Write Pointer Logic
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr_buff <= 0;
            wptr <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_buff <= wptr;
            wptr <= {wptr[1:0], wptr[2] ^ wptr[1]};
        end else begin
            wptr_buff <= wptr;
        end
    end

    // Read Pointer Logic
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr_syn <= 0;
            rptr_buff <= 0;
            rptr <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr_buff <= rptr;
            rptr <= {rptr[1:0], rptr[2] ^ rptr[1]};
            rptr_syn <= rptr;
        end else begin
            rptr_syn <= rptr_buff;
        end
    end

    // Write Enable Logic
    assign wenc = winc;

    // Read Enable Logic
    assign renc = rinc;

    // Write Address Logic
    assign waddr = waddr_bin[$clog2(DEPTH)-1:0];

    // Read Address Logic
    assign raddr = raddr_bin[$clog2(DEPTH)-1:0];

    // Full Signal Logic
    assign wfull = (wptr == {~rptr_syn[2], rptr_syn[1:0]});

    // Empty Signal Logic
    assign rempty = (rptr == wptr);

endmodule

module dual_port_RAM #
    (parameter DEPTH = 16,
     parameter WIDTH = 8)
    (input wclk, 
     input wenc, 
     input [$clog2(DEPTH)-1:0] waddr, 
     input [WIDTH-1:0] wdata, 
     input rclk, 
     input renc, 
     input [$clog2(DEPTH)-1:0] raddr, 
     output [WIDTH-1:0] rdata);

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Initialize RAM
    initial begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM_MEM[i] = 0;
        end
    end

    // Write Logic
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read Logic
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            rdata <= 0;
        end
    end

endmodule
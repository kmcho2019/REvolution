module asyn_fifo #
    (
        parameter DEPTH = 16,
        parameter WIDTH = 8
    )
    (
        input             wclk,      // Write clock signal
        input             rclk,      // Read clock signal
        input             wrstn,     // Write reset signal
        input             rrstn,     // Read reset signal
        input             winc,      // Write increment signal
        input             rinc,      // Read increment signal
        input   [WIDTH-1:0] wdata,   // Write data input
        output            wfull,     // Write full signal
        output            rempty,    // Read empty signal
        output [WIDTH-1:0] rdata     // Read data output
    );

    localparam WADDR_WIDTH = $clog2(DEPTH);

    // Dual-port RAM module instantiation
    dual_port_RAM #
        (
            .WIDTH(WIDTH),
            .DEPTH(DEPTH)
        )
    u_dual_port_RAM
        (
            .wclk(wclk),
            .wenc(wen),
            .waddr(waddr),
            .wdata(wdata),
            .rclk(rclk),
            .renc(ren),
            .raddr(raddr),
            .rdata(rdata)
        );

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    reg [WADDR_WIDTH-1:0] waddr_bin;
    reg [WADDR_WIDTH-1:0] raddr_bin;
    reg [WADDR_WIDTH-1:0] wptr;
    reg [WADDR_WIDTH-1:0] rptr;
    reg [WADDR_WIDTH-1:0] wptr_buff;
    reg [WADDR_WIDTH-1:0] rptr_buff;
    reg [WADDR_WIDTH-1:0] rptr_syn;

    wire wfull;
    wire rempty;

    // Write pointer management
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Read pointer management
    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray code conversion for write pointer
    always @(*) begin
        wptr <= {waddr_bin[WADDR_WIDTH-1], waddr_bin[WADDR_WIDTH-1:1] ^ waddr_bin[WADDR_WIDTH-2:0]};
    end

    // Gray code conversion for read pointer
    always @(*) begin
        rptr <= {raddr_bin[WADDR_WIDTH-1], raddr_bin[WADDR_WIDTH-1:1] ^ raddr_bin[WADDR_WIDTH-2:0]};
    end

    // Buffer for write pointer
    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
        end
    end

    // Buffer for read pointer
    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr;
        end
    end

    // Two-stage trigger for read pointer synchronization
    always @(posedge wclk) begin
        rptr_syn <= rptr_buff;
    end

    // Empty and full signals generation
    assign wfull = (wptr == {~rptr_syn[WADDR_WIDTH-1], rptr_syn[WADDR_WIDTH-2:0]});
    assign rempty = (rptr == wptr);

    // RAM connections
    assign waddr = waddr_bin[WADDR_WIDTH-2:0];
    assign raddr = rptr[WADDR_WIDTH-2:0];
    assign wen = winc;
    assign ren = rinc;

endmodule

module dual_port_RAM #
    (
        parameter WIDTH = 8,
        parameter DEPTH = 16
    )
    (
        input             wclk,      // Write clock signal
        input             wenc,      // Write enable signal
        input   [3:0]     waddr,     // Write address
        input   [WIDTH-1:0] wdata,   // Write data input
        input             rclk,      // Read clock signal
        input             renc,      // Read enable signal
        input   [3:0]     raddr,     // Read address
        output  [WIDTH-1:0] rdata     // Read data output
    );

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            rdata <= 'b0;
        end
    end

endmodule
module asyn_fifo #
    (
        parameter DEPTH = 16,
        parameter WIDTH = 8
    )
    (
        input  wclk,     // Write clock signal
        input  rclk,     // Read clock signal
        input  wrstn,    // Write reset signal (active low)
        input  rrstn,    // Read reset signal (active low)
        input  winc,     // Write increment signal
        input  rinc,     // Read increment signal
        input  [WIDTH-1:0] wdata,  // Write data input
        output reg  wfull, // Write full signal
        output reg  rempty, // Read empty signal
        output reg [WIDTH-1:0] rdata  // Read data output
    );

    // Dual-port RAM module
    wire [WIDTH-1:0] rdata_ram;
    wire wenc, renc;
    reg  [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    reg  [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
    reg  [3:0] wptr, rptr, wptr_syn, rptr_syn;
    reg  [3:0] wptr_buff, rptr_buff;

    // Instantiate dual-port RAM module
    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) u_dual_port_ram
    (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr_bin),
        .rdata(rdata_ram)
    );

    // Write controller
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_buff <= wptr;
            wptr <= {wptr[2:0], wptr[3] ^ wptr[2]};
        end
    end

    // Read controller
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr_buff <= rptr;
            rptr <= {rptr[2:0], rptr[3] ^ rptr[2]};
        end
    end

    // Read pointer synchronizer
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_syn <= 0;
        end else begin
            rptr_syn <= rptr_buff;
        end
    end

    // Write pointer synchronizer
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_syn <= 0;
        end else begin
            wptr_syn <= wptr_buff;
        end
    end

    // Empty and full signals
    always @(posedge wclk or posedge rclk) begin
        if (wptr_syn == rptr) begin
            rempty <= 1'b1;
        end else begin
            rempty <= 1'b0;
        end

        if ((wptr_syn[3:2] == ~rptr_syn[3:2]) && (wptr_syn[1:0] == rptr_syn[1:0])) begin
            wfull <= 1'b1;
        end else begin
            wfull <= 1'b0;
        end
    end

    // Output connections
    always @(posedge wclk) begin
        wenc <= winc;
    end

    always @(posedge rclk) begin
        renc <= rinc;
        rdata <= rdata_ram;
    end

endmodule

module dual_port_RAM #
    (
        parameter WIDTH = 8,
        parameter DEPTH = 16
    )
    (
        input  wclk,     // Write clock signal
        input  wenc,     // Write enable signal
        input  [$clog2(DEPTH)-1:0] waddr,  // Write address
        input  [WIDTH-1:0] wdata,  // Write data input
        input  rclk,     // Read clock signal
        input  renc,     // Read enable signal
        input  [$clog2(DEPTH)-1:0] raddr,  // Read address
        output reg [WIDTH-1:0] rdata  // Read data output
    );

    reg  [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

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
module asyn_fifo
    #(
        parameter WIDTH = 8,
        parameter DEPTH = 16
    )
    (
        input wclk,     // Write clock signal
        input rclk,     // Read clock signal
        input wrstn,    // Write reset signal
        input rrstn,    // Read reset signal
        input winc,     // Write increment signal
        input rinc,     // Read increment signal
        input [WIDTH-1:0] wdata,    // Write data input
        output wfull,   // Write full signal
        output rempty,  // Read empty signal
        output [WIDTH-1:0] rdata    // Read data output
    );

    // Dual-port RAM instantiation
    dual_port_RAM
    #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    )
    dual_port_RAM_inst
    (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    // Write pointer binary register
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    // Read pointer binary register
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    // Write pointer Gray code register
    reg [$clog2(DEPTH)-1:0] wptr;
    // Read pointer Gray code register
    reg [$clog2(DEPTH)-1:0] rptr;
    // Synchronized read pointer Gray code register
    reg [$clog2(DEPTH)-1:0] rptr_syn;

    // Write pointer buffer register
    reg [$clog2(DEPTH)-1:0] wptr_buff;
    // Read pointer buffer register
    reg [$clog2(DEPTH)-1:0] rptr_buff;

    // Write enable signal
    reg wen;
    // Read enable signal
    reg ren;

    // Write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
            wen <= 0;
        end else begin
            if (winc) begin
                waddr_bin <= waddr_bin + 1;
                wptr <= waddr_bin ^ (waddr_bin >> 1);
                wptr_buff <= wptr;
                wen <= 1;
            end else begin
                wen <= 0;
            end
        end
    end

    // Read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
            ren <= 0;
        end else begin
            if (rinc) begin
                raddr_bin <= raddr_bin + 1;
                rptr <= raddr_bin ^ (raddr_bin >> 1);
                rptr_buff <= rptr;
                ren <= 1;
            end else begin
                ren <= 0;
            end
        end
    end

    // Synchronize read pointer to write clock domain
    always @(posedge wclk) begin
        rptr_syn <= rptr_buff;
    end

    // Empty and full signal generation
    assign wfull = (wptr == (~rptr_syn[$clog2(DEPTH)-1] << ($clog2(DEPTH)-1)) | rptr_syn[$clog2(DEPTH)-2:$clog2(DEPTH)-3]);
    assign rempty = (wptr == rptr);

endmodule

module dual_port_RAM
    #(
        parameter WIDTH = 8,
        parameter DEPTH = 16
    )
    (
        input wclk,     // Write clock signal
        input wenc,     // Write enable signal
        input [$clog2(DEPTH)-1:0] waddr,    // Write address
        input [WIDTH-1:0] wdata,    // Write data
        input rclk,     // Read clock signal
        input renc,     // Read enable signal
        input [$clog2(DEPTH)-1:0] raddr,    // Read address
        output reg [WIDTH-1:0] rdata    // Read data
    );

    // RAM memory
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write clock domain
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read clock domain
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
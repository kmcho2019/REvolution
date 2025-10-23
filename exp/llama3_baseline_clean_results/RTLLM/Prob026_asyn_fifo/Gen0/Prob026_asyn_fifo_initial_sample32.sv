module dual_port_RAM(
    input wclk, 
    input wenc, 
    input [$clog2(DEPTH)-1:0] waddr, 
    input [WIDTH-1:0] wdata, 
    input rclk, 
    input renc, 
    input [$clog2(DEPTH)-1:0] raddr, 
    output reg [WIDTH-1:0] rdata
);
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    
    always @(posedge wclk) begin
        if(wenc)
            RAM_MEM[waddr] <= wdata;
    end
    
    always @(posedge rclk) begin
        if(renc)
            rdata <= RAM_MEM[raddr];
    end
endmodule

module asyn_fifo(
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

    parameter DEPTH = 16;
    parameter WIDTH = 8;

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [$clog2(DEPTH)-1:0] wptr_syn;
    reg [$clog2(DEPTH)-1:0] rptr_syn;
    reg [$clog2(DEPTH)-1:0] wptr_buff;
    reg [$clog2(DEPTH)-1:0] rptr_buff;

    assign wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
    assign rempty = (rptr_syn == wptr);

    always @(posedge wclk) begin
        if(~wrstn)
            waddr_bin <= 0;
        else if(winc)
            waddr_bin <= waddr_bin + 1;
    end

    always @(posedge rclk) begin
        if(~rrstn)
            raddr_bin <= 0;
        else if(rinc)
            raddr_bin <= raddr_bin + 1;
    end

    always @(posedge wclk) begin
        wptr <= {waddr_bin[$clog2(DEPTH)-1] ^ waddr_bin[$clog2(DEPTH)-2], 
                  waddr_bin[$clog2(DEPTH)-2] ^ waddr_bin[$clog2(DEPTH)-3], 
                  waddr_bin[$clog2(DEPTH)-3]};
    end

    always @(posedge rclk) begin
        rptr <= {raddr_bin[$clog2(DEPTH)-1] ^ raddr_bin[$clog2(DEPTH)-2], 
                  raddr_bin[$clog2(DEPTH)-2] ^ raddr_bin[$clog2(DEPTH)-3], 
                  raddr_bin[$clog2(DEPTH)-3]};
    end

    always @(posedge wclk) begin
        wptr_buff <= wptr;
    end

    always @(posedge rclk) begin
        rptr_buff <= rptr;
    end

    always @(posedge rclk) begin
        wptr_syn <= wptr_buff;
    end

    always @(posedge wclk) begin
        rptr_syn <= rptr_buff;
    end

    dual_port_RAM RAM(
        .wclk(wclk), 
        .wenc(winc), 
        .waddr(waddr_bin[$clog2(DEPTH)-1:0]), 
        .wdata(wdata), 
        .rclk(rclk), 
        .renc(rinc), 
        .raddr(raddr_bin[$clog2(DEPTH)-1:0]), 
        .rdata(rdata)
    );
endmodule
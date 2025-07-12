module dual_port_RAM(
    input wclk, 
    input wenc, 
    input [4:0] waddr, 
    input [7:0] wdata, 
    input rclk, 
    input renc, 
    input [4:0] raddr, 
    output reg [7:0] rdata
);

    reg [7:0] RAM_MEM [15:0];

    always @(posedge wclk) begin
        if(wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if(renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule

module asyn_fifo(
    input wclk, 
    input rclk, 
    input wrstn, 
    input rrstn, 
    input winc, 
    input rinc, 
    input [7:0] wdata, 
    output reg wfull, 
    output reg rempty, 
    output reg [7:0] rdata
);

    reg [4:0] waddr_bin;
    reg [4:0] raddr_bin;
    reg [3:0] wptr;
    reg [3:0] rptr;
    reg [3:0] wptr_syn;
    reg [3:0] rptr_syn;

    assign wfull = (wptr == ~rptr_syn[3] && rptr_syn[2:0] == wptr[2:0]);
    assign rempty = (rptr_syn == wptr);

    always @(posedge wclk) begin
        if(~wrstn) begin
            waddr_bin <= 0;
        end
        else if(winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    always @(posedge rclk) begin
        if(~rrstn) begin
            raddr_bin <= 0;
        end
        else if(rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    always @(posedge wclk) begin
        wptr[0] <= waddr_bin[0];
        wptr[1] <= waddr_bin[1] ^ waddr_bin[0];
        wptr[2] <= waddr_bin[2] ^ waddr_bin[1];
        wptr[3] <= waddr_bin[3] ^ waddr_bin[2];
    end

    always @(posedge rclk) begin
        rptr[0] <= raddr_bin[0];
        rptr[1] <= raddr_bin[1] ^ raddr_bin[0];
        rptr[2] <= raddr_bin[2] ^ raddr_bin[1];
        rptr[3] <= raddr_bin[3] ^ raddr_bin[2];
    end

    always @(posedge wclk) begin
        wptr_syn <= rptr;
    end

    always @(posedge rclk) begin
        rptr_syn <= wptr;
    end

    dual_port_RAM ram(
        .wclk(wclk), 
        .wenc(winc), 
        .waddr(waddr_bin), 
        .wdata(wdata), 
        .rclk(rclk), 
        .renc(rinc), 
        .raddr(raddr_bin), 
        .rdata(rdata)
    );

endmodule
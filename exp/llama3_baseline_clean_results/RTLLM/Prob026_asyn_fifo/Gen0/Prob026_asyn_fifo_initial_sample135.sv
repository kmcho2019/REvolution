module dual_port_RAM (
    input wclk, 
    input wenc, 
    input [$clog2(DEPTH)-1:0] waddr, 
    input [WIDTH-1:0] wdata, 
    input rclk, 
    input renc, 
    input [$clog2(DEPTH)-1:0] raddr, 
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

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

module asyn_fifo (
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

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
    wire [WIDTH-1:0] rdata_wire;

    dual_port_RAM ram_inst (
        .wclk(wclk), 
        .wenc(winc), 
        .waddr(wptr_bin), 
        .wdata(wdata), 
        .rclk(rclk), 
        .renc(rinc), 
        .raddr(rptr_bin), 
        .rdata(rdata_wire)
    );

    reg [$clog2(DEPTH)-1:0] wptr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_bin;
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [$clog2(DEPTH)-1:0] wptr_syn;
    reg [$clog2(DEPTH)-1:0] rptr_syn;

    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end else if (winc) begin
            wptr_bin <= wptr_bin + 1;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

    always @(posedge wclk) begin
        wptr <= wptr_bin ^ (wptr_bin >> 1);
    end

    always @(posedge rclk) begin
        rptr <= rptr_bin ^ (rptr_bin >> 1);
    end

    reg [$clog2(DEPTH)-1:0] wptr_buff;
    reg [$clog2(DEPTH)-1:0] rptr_buff;

    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr;
        end
    end

    always @(posedge wclk) begin
        wptr_syn <= rptr_buff;
    end

    always @(posedge rclk) begin
        rptr_syn <= wptr_buff;
    end

    always @(posedge rclk) begin
        if (rptr_syn == rptr) begin
            rempty <= 1'b1;
        end else begin
            rempty <= 1'b0;
        end
    end

    always @(posedge wclk) begin
        if ({~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]} == wptr) begin
            wfull <= 1'b1;
        end else begin
            wfull <= 1'b0;
        end
    end

    always @(posedge rclk) begin
        rdata <= rdata_wire;
    end

endmodule
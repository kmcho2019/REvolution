module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wclk, 
    input  rclk, 
    input  wrstn, 
    input  rrstn, 
    input  winc, 
    input  rinc, 
    input  [WIDTH-1:0] wdata, 
    output reg wfull, 
    output reg rempty, 
    output reg [WIDTH-1:0] rdata
);

    // Dual-port RAM module
    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata_ram)
    );

    // Data write controller
    reg [WIDTH-1:0] rdata_ram;
    reg [WIDTH-1:0] rdata;
    reg wen;
    reg [WIDTH-1:0] rdata_reg;

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr <= 0;
            wfull <= 0;
            wen <= 0;
        end else if (winc && ~wfull) begin
            waddr <= waddr + 1;
            wen <= 1;
        end else begin
            wen <= 0;
        end
    end

    // Data read controller
    reg ren;
    reg [WIDTH-1:0] raddr;

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr <= 0;
            rempty <= 1;
            ren <= 0;
        end else if (rinc && ~rempty) begin
            raddr <= raddr + 1;
            ren <= 1;
        end else begin
            ren <= 0;
        end
    end

    // Read pointer synchronizer
    reg [$clog2(DEPTH)-1:0] rptr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_bin_syn;
    reg [WIDTH-1:0] rptr;
    reg [WIDTH-1:0] rptr_syn;
    reg [WIDTH-1:0] rptr_buff;

    always @(posedge wclk) begin
        rptr_bin_syn <= rptr_bin;
        rptr_syn <= {rptr_bin_syn[$clog2(DEPTH)-1], rptr_bin_syn[$clog2(DEPTH)-2:0]};
    end

    always @(posedge rclk) begin
        rptr_bin <= raddr;
        rptr <= {rptr_bin[$clog2(DEPTH)-1], rptr_bin[$clog2(DEPTH)-2:0]};
        rptr_buff <= rptr;
    end

    // Write pointer synchronizer
    reg [$clog2(DEPTH)-1:0] wptr_bin;
    reg [$clog2(DEPTH)-1:0] wptr_bin_syn;
    reg [WIDTH-1:0] wptr;
    reg [WIDTH-1:0] wptr_syn;
    reg [WIDTH-1:0] wptr_buff;

    always @(posedge rclk) begin
        wptr_bin_syn <= wptr_bin;
        wptr_syn <= {wptr_bin_syn[$clog2(DEPTH)-1], wptr_bin_syn[$clog2(DEPTH)-2:0]};
    end

    always @(posedge wclk) begin
        wptr_bin <= waddr;
        wptr <= {wptr_bin[$clog2(DEPTH)-1], wptr_bin[$clog2(DEPTH)-2:0]};
        wptr_buff <= wptr;
    end

    // Gray code conversion
    reg [WIDTH-1:0] wgray;
    reg [WIDTH-1:0] rgray;

    always @(posedge wclk) begin
        wgray <= wptr ^ (wptr >> 1);
    end

    always @(posedge rclk) begin
        rgray <= rptr ^ (rptr >> 1);
    end

    // Full and empty signals
    always @(posedge wclk) begin
        if (wgray == {~rgray[$clog2(DEPTH)-1], rgray[$clog2(DEPTH)-2:0]}) begin
            wfull <= 1;
        end else begin
            wfull <= 0;
        end
    end

    always @(posedge rclk) begin
        if (rgray == wgray) begin
            rempty <= 1;
        end else begin
            rempty <= 0;
        end
    end

    // Output connections
    always @(posedge rclk) begin
        if (ren) begin
            rdata_reg <= rdata_ram;
        end
    end

    assign rdata = rdata_reg;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wclk, 
    input  wenc, 
    input  [$clog2(DEPTH)-1:0] waddr, 
    input  [WIDTH-1:0] wdata, 
    input  rclk, 
    input  renc, 
    input  [$clog2(DEPTH)-1:0] raddr, 
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

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
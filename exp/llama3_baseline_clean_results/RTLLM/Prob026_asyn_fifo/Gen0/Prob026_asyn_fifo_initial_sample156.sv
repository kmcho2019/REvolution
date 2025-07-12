// Define the dual-port RAM module
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
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end
    
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            rdata <= 'bz;
        end
    end
endmodule

// Define the asynchronous FIFO module
module asyn_fifo(
    input wclk, 
    input rclk, 
    input wrstn, 
    input rrstn, 
    input winc, 
    input rinc, 
    input [WIDTH-1:0] wdata, 
    output wfull, 
    output rempty, 
    output [WIDTH-1:0] rdata
);
    parameter DEPTH = 16;
    parameter WIDTH = 8;
    localparam AW = $clog2(DEPTH);
    
    reg [AW-1:0] waddr_bin, raddr_bin;
    reg [AW:0] wptr, rptr, wptr_buff, rptr_buff;
    reg [WIDTH-1:0] rdata_out;
    reg wfull_out, rempty_out;
    
    // Instantiate the dual-port RAM module
    dual_port_RAM RAM(
        .wclk(wclk), 
        .wenc(winc), 
        .waddr(waddr_bin), 
        .wdata(wdata), 
        .rclk(rclk), 
        .renc(rinc), 
        .raddr(raddr_bin), 
        .rdata(rdata_out)
    );
    
    // Write pointer controller
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end
    
    // Read pointer controller
    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end
    
    // Convert write pointer to Gray code
    always @(posedge wclk) begin
        wptr <= {1'b0, waddr_bin} ^ ({1'b0, waddr_bin} >> 1);
    end
    
    // Synchronize write pointer to read clock domain
    reg [AW:0] wptr_syn;
    always @(posedge rclk) begin
        wptr_buff <= wptr;
        wptr_syn <= wptr_buff;
    end
    
    // Convert read pointer to Gray code
    always @(posedge rclk) begin
        rptr <= {1'b0, raddr_bin} ^ ({1'b0, raddr_bin} >> 1);
    end
    
    // Synchronize read pointer to write clock domain
    reg [AW:0] rptr_syn;
    always @(posedge wclk) begin
        rptr_buff <= rptr;
        rptr_syn <= rptr_buff;
    end
    
    // Determine full condition
    always @(*) begin
        if (wptr_syn[AW] != rptr[AW] && wptr_syn[AW-1:0] == rptr[AW-1:0]) begin
            wfull_out <= 1'b1;
        end else begin
            wfull_out <= 1'b0;
        end
    end
    
    // Determine empty condition
    always @(*) begin
        if (rptr_syn == wptr) begin
            rempty_out <= 1'b1;
        end else begin
            rempty_out <= 1'b0;
        end
    end
    
    assign wfull = wfull_out;
    assign rempty = rempty_out;
    assign rdata = rdata_out;
endmodule
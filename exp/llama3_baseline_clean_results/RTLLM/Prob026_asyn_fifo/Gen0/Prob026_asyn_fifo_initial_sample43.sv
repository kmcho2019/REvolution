module asyn_fifo (
    input  logic             wclk, 
    input  logic             rclk, 
    input  logic             wrstn, 
    input  logic             rrstn, 
    input  logic             winc, 
    input  logic             rinc, 
    input  logic [7:0]       wdata, 
    output logic             wfull, 
    output logic             rempty, 
    output logic [7:0]       rdata
);

parameter DEPTH = 16;
parameter WIDTH = 8;

// Dual-port RAM module
module dual_port_RAM (
    input  logic             wclk, 
    input  logic             rclk, 
    input  logic             wenc, 
    input  logic [3:0]       waddr, 
    input  logic [7:0]       wdata, 
    input  logic             renc, 
    input  logic [3:0]       raddr, 
    output logic [7:0]       rdata
);
    logic [7:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk) begin
        if (~wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end
endmodule

// Write and Read Pointers
logic [3:0] waddr_bin;
logic [3:0] raddr_bin;
logic [3:0] wptr;
logic [3:0] rptr;

// Gray Code Conversion
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr <= (waddr_bin[3] ^ waddr_bin[2]) ? {waddr_bin[3:2], waddr_bin[1:0] ^ {2'b01, 1'b0}} : {waddr_bin[3:2], waddr_bin[1:0]};
end

always @(posedge rclk) begin
    rptr <= (raddr_bin[3] ^ raddr_bin[2]) ? {raddr_bin[3:2], raddr_bin[1:0] ^ {2'b01, 1'b0}} : {raddr_bin[3:2], raddr_bin[1:0]};
end

// Pointer Buffers
logic [3:0] wptr_buff;
logic [3:0] rptr_buff;
logic [3:0] rptr_syn;
logic [3:0] wptr_syn;

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

// Full and Empty Signals
always @(*) begin
    wfull = (wptr[3:2] != rptr_syn[3:2] && wptr[1:0] == rptr_syn[1:0]);
    rempty = (wptr == rptr_syn);
end

// Input and Output Connections
logic wenc;
logic renc;

always @(*) begin
    wenc = winc;
    renc = rinc;
end

dual_port_RAM RAM (
    .wclk(wclk),
    .rclk(rclk),
    .wenc(wenc),
    .waddr(wptr[2:0]),
    .wdata(wdata),
    .renc(renc),
    .raddr(rptr[2:0]),
    .rdata(rdata)
);

endmodule
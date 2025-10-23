module asyn_fifo(
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

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    // Dual-port RAM
    wire [WIDTH-1:0] ram_rdata;
    reg [WIDTH-1:0] ram_wdata;
    reg wenc, renc;
    reg [$clog2(DEPTH)-1:0] waddr, raddr;

    // Write Pointer Management Unit
    reg [WIDTH-1:0] wptr_bin;
    reg [WIDTH-1:0] wptr_gray;
    reg [WIDTH-1:0] wptr_syn;

    // Read Pointer Management Unit
    reg [WIDTH-1:0] rptr_bin;
    reg [WIDTH-1:0] rptr_gray;
    reg [WIDTH-1:0] rptr_syn;

    // Synchronization Mechanism
    reg [WIDTH-1:0] wptr_syn_buf1, wptr_syn_buf2;
    reg [WIDTH-1:0] rptr_syn_buf1, rptr_syn_buf2;

    // Full and Empty Conditions
    reg wfull_reg;
    reg rempty_reg;

    // Dual-port RAM Instantiation
    dual_port_RAM ram_inst(
        .wclk(wclk),
        .renc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .ren(renc),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Write Pointer Increment
    always @(posedge wclk or negedge wrstn)
    begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end
        else if (winc) begin
            wptr_bin <= (wptr_bin + 1) % DEPTH;
        end
    end

    // Read Pointer Increment
    always @(posedge rclk or negedge rrstn)
    begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end
        else if (rinc) begin
            rptr_bin <= (rptr_bin + 1) % DEPTH;
        end
    end

    // Gray Code Conversion
    always @(*)
    begin
        wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
        rptr_gray = (rptr_bin >> 1) ^ rptr_bin;
    end

    // Synchronization Mechanism
    always @(posedge rclk)
    begin
        wptr_syn_buf1 <= wptr_gray;
        wptr_syn_buf2 <= wptr_syn_buf1;
        wptr_syn <= wptr_syn_buf2;
    end

    always @(posedge wclk)
    begin
        rptr_syn_buf1 <= rptr_gray;
        rptr_syn_buf2 <= rptr_syn_buf1;
        rptr_syn <= rptr_syn_buf2;
    end

    // Full and Empty Conditions
    always @(*)
    begin
        if (wptr_syn == {~rptr_syn[WIDTH-1], rptr_syn[WIDTH-2:0]}) begin
            wfull_reg <= 1;
        end
        else begin
            wfull_reg <= 0;
        end

        if (rptr_syn == wptr_syn) begin
            rempty_reg <= 1;
        end
        else begin
            rempty_reg <= 0;
        end
    end

    // Output Assignments
    assign wfull = wfull_reg;
    assign rempty = rempty_reg;
    assign rdata = ram_rdata;

    // Write and Read Enable Signals
    always @(posedge wclk)
    begin
        wenc <= winc;
        waddr <= wptr_bin;
    end

    always @(posedge rclk)
    begin
        renc <= rinc;
        raddr <= rptr_bin;
    end

endmodule

module dual_port_RAM(
    input  wclk, 
    input  renc, 
    input  [$clog2(DEPTH)-1:0] waddr, 
    input  [WIDTH-1:0] wdata, 
    input  rclk, 
    input  ren, 
    input  [$clog2(DEPTH)-1:0] raddr, 
    output reg [WIDTH-1:0] rdata
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always @(posedge wclk)
    begin
        if (renc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk)
    begin
        if (ren) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
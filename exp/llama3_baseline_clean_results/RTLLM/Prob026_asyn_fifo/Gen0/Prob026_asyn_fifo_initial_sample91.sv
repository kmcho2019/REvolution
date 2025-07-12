// asyn_fifo.v

module asyn_fifo (
    input               wclk, 
    input               rclk, 
    input               wrstn, 
    input               rrstn, 
    input               winc, 
    input               rinc, 
    input       [WIDTH-1:0] wdata, 
    output reg          wfull, 
    output reg          rempty, 
    output reg [WIDTH-1:0] rdata
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [WIDTH-1:0] ram_mem [DEPTH-1:0];

    // Dual-port RAM
    module dual_port_RAM (
        input               wclk, 
        input               wenc, 
        input       [$clog2(DEPTH)-1:0] waddr, 
        input       [WIDTH-1:0] wdata, 
        input               rclk, 
        input               renc, 
        input       [$clog2(DEPTH)-1:0] raddr, 
        output reg   [WIDTH-1:0] rdata
    );

        always @(posedge wclk) begin
            if (wenc) begin
                ram_mem[waddr] <= wdata;
            end
        end

        always @(posedge rclk) begin
            if (renc) begin
                rdata <= ram_mem[raddr];
            end
        end

    endmodule

    // Write and Read Pointers
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    // Gray Code Conversion
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [$clog2(DEPTH)-1:0] wptr_buff;
    reg [$clog2(DEPTH)-1:0] rptr_buff;

    // Full and Empty Signals
    reg wfull_reg;
    reg rempty_reg;

    // Input and Output Connections
    wire wenc;
    wire renc;
    wire [$clog2(DEPTH)-1:0] waddr;
    wire [$clog2(DEPTH)-1:0] raddr;
    wire [WIDTH-1:0] rdata_out;

    // Instantiate Dual-Port RAM
    dual_port_RAM ram_inst (
       .wclk(wclk), 
       .wenc(wenc), 
       .waddr(waddr), 
       .wdata(wdata), 
       .rclk(rclk), 
       .renc(renc), 
       .raddr(raddr), 
       .rdata(rdata_out)
    );

    // Write Pointer Logic
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Read Pointer Logic
    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray Code Conversion
    always @(posedge wclk) begin
        wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-1:1] ^ waddr_bin[$clog2(DEPTH)-2:0]};
        wptr_buff <= wptr;
    end

    always @(posedge rclk) begin
        rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-1:1] ^ raddr_bin[$clog2(DEPTH)-2:0]};
        rptr_buff <= rptr;
    end

    // Full and Empty Signals
    always @(posedge wclk) begin
        if (wptr == {~rptr[$clog2(DEPTH)-1], rptr[$clog2(DEPTH)-2:0]}) begin
            wfull_reg <= 1'b1;
        end else begin
            wfull_reg <= 1'b0;
        end
    end

    always @(posedge rclk) begin
        if (rptr == wptr_buff) begin
            rempty_reg <= 1'b1;
        end else begin
            rempty_reg <= 1'b0;
        end
    end

    // Input and Output Connections
    assign wenc = winc;
    assign renc = rinc;
    assign waddr = waddr_bin[$clog2(DEPTH)-1:0];
    assign raddr = raddr_bin[$clog2(DEPTH)-1:0];
    assign rdata = rdata_out;
    assign wfull = wfull_reg;
    assign rempty = rempty_reg;

endmodule
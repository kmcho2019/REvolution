module asyn_fifo 
#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
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

    // Dual-port RAM module
    module dual_port_RAM 
    #(
        parameter WIDTH = 8,
        parameter DEPTH = 16
    )
    (
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

        always @(posedge wclk) 
        begin
            if (wenc) 
            begin
                RAM_MEM[waddr] <= wdata;
            end
        end

        always @(posedge rclk) 
        begin
            if (renc) 
            begin
                rdata <= RAM_MEM[raddr];
            end
        end

    endmodule

    // Instantiating the dual-port RAM module
    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_instance 
    (
        .wclk(wclk), 
        .wenc(wen), 
        .waddr(waddr), 
        .wdata(wdata), 
        .rclk(rclk), 
        .renc(ren), 
        .raddr(raddr), 
        .rdata(rdata_out)
    );

    // Signals and registers
    reg [WIDTH-1:0] rdata_out;
    reg wfull_int, rempty_int;
    reg [$clog2(DEPTH)-1:0] waddr, raddr;
    reg [1:0] wptr_buff, rptr_buff;
    reg [1:0] wptr, rptr;
    reg wen, ren;

    // Write pointer controller
    always @(posedge wclk) 
    begin
        if (~wrstn) 
        begin
            waddr <= 0;
        end
        else if (winc) 
        begin
            waddr <= waddr + 1;
        end
    end

    // Read pointer controller
    always @(posedge rclk) 
    begin
        if (~rrstn) 
        begin
            raddr <= 0;
        end
        else if (rinc) 
        begin
            raddr <= raddr + 1;
        end
    end

    // Gray code conversion
    always @(posedge wclk) 
    begin
        wptr_buff <= wptr_buff + 1;
        wptr <= {wptr_buff[1], wptr_buff[0] ^ wptr_buff[1]};
    end

    always @(posedge rclk) 
    begin
        rptr_buff <= rptr_buff + 1;
        rptr <= {rptr_buff[1], rptr_buff[0] ^ rptr_buff[1]};
    end

    // Synchronization logic
    reg [1:0] rptr_syn;
    always @(posedge wclk) 
    begin
        rptr_syn <= rptr;
    end

    // Full and empty signals
    always @(*) 
    begin
        wfull_int = (wptr == {~rptr_syn[1], rptr_syn[0]});
        rempty_int = (rptr == wptr);
    end

    // Output assignments
    assign wfull = wfull_int;
    assign rempty = rempty_int;
    assign rdata = rdata_out;

    // Enable signals
    always @(*) 
    begin
        wen = winc;
        ren = rinc;
    end

endmodule
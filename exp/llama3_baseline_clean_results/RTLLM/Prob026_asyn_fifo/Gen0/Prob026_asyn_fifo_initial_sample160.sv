module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input  wclk,  // Write clock signal
    input  rclk,  // Read clock signal
    input  wrstn, // Write reset signal
    input  rrstn, // Read reset signal
    input  winc,  // Write increment signal
    input  rinc,  // Read increment signal
    input  [WIDTH-1:0] wdata, // Write data input
    output wfull, // Write full signal
    output rempty, // Read empty signal
    output [WIDTH-1:0] rdata // Read data output
);

    // Define the dual-port RAM module
    module dual_port_RAM #(
        parameter DEPTH = 16,
        parameter WIDTH = 8
    ) (
        input  wclk,  // Write clock signal
        input  wenc,  // Write enable signal
        input  [$clog2(DEPTH)-1:0] waddr, // Write address
        input  [WIDTH-1:0] wdata, // Write data input
        input  rclk,  // Read clock signal
        input  renc,  // Read enable signal
        input  [$clog2(DEPTH)-1:0] raddr, // Read address
        output [WIDTH-1:0] rdata // Read data output
    );
        reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0]; // RAM memory

        // Write logic
        always @(posedge wclk) begin
            if (wenc) begin
                RAM_MEM[waddr] <= wdata;
            end
        end

        // Read logic
        always @(posedge rclk) begin
            if (renc) begin
                rdata <= RAM_MEM[raddr];
            end
        end
    endmodule

    // Define the Gray code conversion function
    function [3:0] bin_to_gray;
        input [3:0] bin;
        begin
            bin_to_gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Define the binary to Gray code conversion for write and read pointers
    reg [3:0] wptr_bin, rptr_bin;
    reg [3:0] wptr, rptr;

    // Write pointer logic
    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end else if (winc) begin
            wptr_bin <= (wptr_bin + 1) % DEPTH;
        end
        wptr <= bin_to_gray(wptr_bin);
    end

    // Read pointer logic
    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= (rptr_bin + 1) % DEPTH;
        end
        rptr <= bin_to_gray(rptr_bin);
    end

    // Write and read enable signals
    reg wen, ren;
    assign wen = winc;
    assign ren = rinc;

    // Write and read address signals
    reg [$clog2(DEPTH)-1:0] waddr, raddr;
    assign waddr = wptr_bin[$clog2(DEPTH)-1:0];
    assign raddr = rptr_bin[$clog2(DEPTH)-1:0];

    // Full and empty signals
    reg wfull_int, rempty_int;
    assign wfull_int = (wptr == {~rptr[3], rptr[2:0]});
    assign rempty_int = (rptr == wptr);

    // Synchronize the read pointer to the write clock domain
    reg [3:0] rptr_syn;
    always @(posedge wclk) begin
        rptr_syn <= rptr;
    end

    // Synchronize the write pointer to the read clock domain
    reg [3:0] wptr_syn;
    always @(posedge rclk) begin
        wptr_syn <= wptr;
    end

    // Assign the full and empty signals
    assign wfull = wfull_int;
    assign rempty = rempty_int;

    // Instantiate the dual-port RAM module
    dual_port_RAM #(
       .DEPTH(DEPTH),
       .WIDTH(WIDTH)
    ) u_ram (
       .wclk(wclk),
       .wenc(wen),
       .waddr(waddr),
       .wdata(wdata),
       .rclk(rclk),
       .renc(ren),
       .raddr(raddr),
       .rdata(rdata)
    );

endmodule
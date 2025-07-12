module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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

    // Define the dual-port RAM module
    module dual_port_RAM #(
        parameter WIDTH = 8,
        parameter DEPTH = 16
    ) (
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
            end
        end
    endmodule

    // Define the Gray code conversion function
    function [3:0] bin_to_gray;
        input [3:0] bin;
        begin
            bin_to_gray = bin ^ (bin >> 1);
        end
    endfunction

    // Define the binary to Gray code conversion function
    function [3:0] gray_to_bin;
        input [3:0] gray;
        begin
            gray_to_bin = gray ^ (gray >> 1);
        end
    endfunction

    // Instantiate the dual-port RAM module
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Define the write pointer register
    reg [3:0] wptr_bin;
    reg [3:0] wptr_gray;

    // Define the read pointer register
    reg [3:0] rptr_bin;
    reg [3:0] rptr_gray;

    // Define the write pointer buffer register
    reg [3:0] wptr_buff;

    // Define the read pointer buffer register
    reg [3:0] rptr_buff;

    // Define the write enable signal
    reg wenc;

    // Define the read enable signal
    reg renc;

    // Initialize the write and read pointers
    initial begin
        wptr_bin = 0;
        wptr_gray = 0;
        rptr_bin = 0;
        rptr_gray = 0;
        wptr_buff = 0;
        rptr_buff = 0;
        wenc = 0;
        renc = 0;
    end

    // Write pointer logic
    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin_to_gray(wptr_bin);
        end
    end

    // Read pointer logic
    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin_to_gray(rptr_bin);
        end
    end

    // Write pointer buffer logic
    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr_bin;
        end
    end

    // Read pointer buffer logic
    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr_bin;
        end
    end

    // Write enable logic
    always @(posedge wclk) begin
        if (winc) begin
            wenc <= 1;
        end else begin
            wenc <= 0;
        end
    end

    // Read enable logic
    always @(posedge rclk) begin
        if (rinc) begin
            renc <= 1;
        end else begin
            renc <= 0;
        end
    end

    // Assign the write and read addresses
    assign waddr = wptr_bin[2:0];
    assign raddr = rptr_bin[2:0];

    // Assign the write full signal
    assign wfull = (wptr_gray == {~rptr_gray[3], rptr_gray[2:0]});

    // Assign the read empty signal
    assign rempty = (wptr_gray == rptr_gray);

endmodule
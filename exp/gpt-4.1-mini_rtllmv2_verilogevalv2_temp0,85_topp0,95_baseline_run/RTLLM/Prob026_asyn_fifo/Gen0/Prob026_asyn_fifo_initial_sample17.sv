module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= {WIDTH{1'b0}}; // Optional: clear output if no read enable
    end

endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1 // One extra bit for full detection
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] waddr_bin, raddr_bin;

    // Gray code write and read pointers
    reg [PTR_WIDTH-1:0] wptr, rptr;

    // Synchronized pointers across clock domains
    reg [PTR_WIDTH-1:0] rptr_syn1, rptr_syn2; // rptr synchronized to wclk domain
    reg [PTR_WIDTH-1:0] wptr_syn1, wptr_syn2; // wptr synchronized to rclk domain

    // Buffered pointers for next cycle
    reg [PTR_WIDTH-1:0] wptr_buff;
    reg [PTR_WIDTH-1:0] rptr_buff;

    // Write and read enables for RAM
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;

    // Convert Gray code to binary function (parameterized)
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Convert binary to Gray code function
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // RAM addresses come from lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr_ram = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = raddr_bin[ADDR_WIDTH-1:0];

    // Instantiate the dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr_ram),
        .rdata(rdata)
    );

    // Write pointer logic (binary counter)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= {PTR_WIDTH{1'b0}};
            wptr <= {PTR_WIDTH{1'b0}};
            wptr_buff <= {PTR_WIDTH{1'b0}};
        end else begin
            if (wenc) begin
                waddr_bin <= waddr_bin + 1'b1;
            end
            wptr <= bin2gray(waddr_bin);
            wptr_buff <= wptr;
        end
    end

    // Read pointer logic (binary counter)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= {PTR_WIDTH{1'b0}};
            rptr <= {PTR_WIDTH{1'b0}};
            rptr_buff <= {PTR_WIDTH{1'b0}};
        end else begin
            if (renc) begin
                raddr_bin <= raddr_bin + 1'b1;
            end
            rptr <= bin2gray(raddr_bin);
            rptr_buff <= rptr;
        end
    end

    // Synchronize read pointer into write clock domain (2-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn1 <= {PTR_WIDTH{1'b0}};
            rptr_syn2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_syn1 <= rptr_buff;
            rptr_syn2 <= rptr_syn1;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn1 <= {PTR_WIDTH{1'b0}};
            wptr_syn2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_syn1 <= wptr_buff;
            wptr_syn2 <= wptr_syn1;
        end
    end

    // Full detection
    // FIFO is full when:
    // wptr_gray == {~rptr_syn_gray[PTR_WIDTH-1:PTR_WIDTH-2], rptr_syn_gray[PTR_WIDTH-3:0]}
    // i.e. MSB and second MSB of wptr are inverse of those of rptr_syn2, rest bits equal
    wire full_test;
    assign full_test =
        (wptr[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_syn2[PTR_WIDTH-1:PTR_WIDTH-2]) &&
        (wptr[PTR_WIDTH-3:0] == rptr_syn2[PTR_WIDTH-3:0]);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_test;
    end

    // Empty detection
    // FIFO is empty when rptr_gray == wptr_syn_gray
    wire empty_test = (rptr == wptr_syn2);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_test;
    end

endmodule
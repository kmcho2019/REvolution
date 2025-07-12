module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input wclk,  // Write clock signal
    input rclk,  // Read clock signal
    input wrstn, // Write reset signal (0 for reset, 1 for inactive)
    input rrstn, // Read reset signal (0 for reset, 1 for inactive)
    input winc,  // Write increment signal
    input rinc,  // Read increment signal
    input [WIDTH-1:0] wdata, // Write data input
    output reg wfull, // Write full signal
    output reg rempty, // Read empty signal
    output reg [WIDTH-1:0] rdata  // Read data output
);

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    wire [WIDTH-1:0] wdata_out;
    reg [WIDTH-1:0] wdata_reg;

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    reg [$clog2(DEPTH)-1:0] wptr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_bin;

    reg [$clog2(DEPTH)-1:0] wptr_syn;
    reg [$clog2(DEPTH)-1:0] rptr_syn;

    wire wenc;
    wire renc;

    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;

    // Write Pointer
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_bin <= waddr_bin;
        end
    end

    // Read Pointer
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr_bin <= raddr_bin;
        end
    end

    // Gray Code Conversion for Write Pointer
    always @(posedge wclk) begin
        wptr_syn <= (wptr_bin[$clog2(DEPTH)-1:1] ^ {1'b0, wptr_bin[$clog2(DEPTH)-2:0]}) + {wptr_bin[$clog2(DEPTH)-1:1], 1'b0};
    end

    // Gray Code Conversion for Read Pointer
    always @(posedge rclk) begin
        rptr_syn <= (rptr_bin[$clog2(DEPTH)-1:1] ^ {1'b0, rptr_bin[$clog2(DEPTH)-2:0]}) + {rptr_bin[$clog2(DEPTH)-1:1], 1'b0};
    end

    // Full and Empty Signals
    always @(*) begin
        if (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
            wfull = 1'b1;
        end else begin
            wfull = 1'b0;
        end

        if (rptr_syn == wptr_syn) begin
            rempty = 1'b1;
        end else begin
            rempty = 1'b0;
        end
    end

    // Dual-Port RAM
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr_bin] <= wdata;
        end
    end

    always @(posedge rclk) begin
        rdata <= RAM_MEM[raddr_bin];
    end

    // Output Assignment
    assign rdata_out = rdata;

endmodule
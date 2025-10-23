module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic wclk, 
    input  logic rstn, 
    input  logic rclk, 
    input  logic rrstn, 
    input  logic winc, 
    input  logic rinc, 
    input  logic [WIDTH-1:0] wdata, 
    output logic wfull, 
    output logic rempty, 
    output logic [WIDTH-1:0] rdata
);

    // Dual Port RAM
    logic wenc, renc;
    logic [$clog2(DEPTH)-1:0] waddr, raddr;
    logic [WIDTH-1:0] rdata_out;

    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata_out)
    );

    // Write Pointer
    logic [$clog2(DEPTH)-1:0] wptr_bin;
    logic [2:0] wptr_gray;
    logic [2:0] wptr_gray_syn;
    always_ff @(posedge wclk or negedge rstn) begin
        if (~rstn) begin
            wptr_bin <= 0;
        end else if (winc) begin
            wptr_bin <= wptr_bin + 1;
        end
    end

    assign wptr_gray = {wptr_bin[$clog2(DEPTH)-1] ^ wptr_bin[$clog2(DEPTH)-2], wptr_bin[$clog2(DEPTH)-2] ^ wptr_bin[$clog2(DEPTH)-3], wptr_bin[$clog2(DEPTH)-3]};
    always_ff @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_syn <= 0;
        end else begin
            wptr_gray_syn <= wptr_gray;
        end
    end

    // Read Pointer
    logic [$clog2(DEPTH)-1:0] rptr_bin;
    logic [2:0] rptr_gray;
    logic [2:0] rptr_gray_syn;
    always_ff @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

    assign rptr_gray = {rptr_bin[$clog2(DEPTH)-1] ^ rptr_bin[$clog2(DEPTH)-2], rptr_bin[$clog2(DEPTH)-2] ^ rptr_bin[$clog2(DEPTH)-3], rptr_bin[$clog2(DEPTH)-3]};
    always_ff @(posedge wclk or negedge rstn) begin
        if (~rstn) begin
            rptr_gray_syn <= 0;
        end else begin
            rptr_gray_syn <= rptr_gray;
        end
    end

    // Write and Read Enable
    always_ff @(posedge wclk) begin
        wenc <= winc;
    end
    always_ff @(posedge rclk) begin
        renc <= rinc;
    end

    // Write and Read Address
    assign waddr = wptr_bin[$clog2(DEPTH)-1:0];
    assign raddr = rptr_bin[$clog2(DEPTH)-1:0];

    // Full and Empty Signals
    logic full;
    logic empty;
    assign full = (wptr_gray_syn == {~rptr_gray[2], rptr_gray[1:0]});
    assign empty = (rptr_gray == wptr_gray_syn);

    // Output Assignments
    assign wfull = full;
    assign rempty = empty;
    assign rdata = rdata_out;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic wclk, 
    input  logic wenc, 
    input  logic [$clog2(DEPTH)-1:0] waddr, 
    input  logic [WIDTH-1:0] wdata, 
    input  logic rclk, 
    input  logic renc, 
    input  logic [$clog2(DEPTH)-1:0] raddr, 
    output logic [WIDTH-1:0] rdata
);

    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always_ff @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always_ff @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
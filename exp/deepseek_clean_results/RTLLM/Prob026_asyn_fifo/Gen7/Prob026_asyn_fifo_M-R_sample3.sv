module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Binary and Gray code pointers
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);
    
    // Synchronized pointers
    wire [PTR_WIDTH-1:0] wptr_sync = sync_ptr(wptr_gray, rclk, rrstn);
    wire [PTR_WIDTH-1:0] rptr_sync = sync_ptr(rptr_gray, wclk, wrstn);
    
    // Convert synced pointers back to binary
    wire [PTR_WIDTH-1:0] wptr_sync_bin = gray2bin(wptr_sync);
    wire [PTR_WIDTH-1:0] rptr_sync_bin = gray2bin(rptr_sync);
    
    // Status flags
    assign wfull = (wptr_gray == {~rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync);
    
    // Memory control
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    
    // Pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wenc) begin
            wptr_bin <= wptr_bin + 1;
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (renc) begin
            rptr_bin <= rptr_bin + 1;
        end
    end
    
    // Dual-port RAM instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
    
    // Gray code conversion functions
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction
    
    // Pointer synchronizer module
    function [PTR_WIDTH-1:0] sync_ptr;
        input [PTR_WIDTH-1:0] ptr;
        input clk;
        input rstn;
        reg [PTR_WIDTH-1:0] sync_reg[1:0];
        begin
            if (!rstn) begin
                sync_reg[0] = 0;
                sync_reg[1] = 0;
            end else begin
                sync_reg[0] = ptr;
                sync_reg[1] = sync_reg[0];
            end
            sync_ptr = sync_reg[1];
        end
    endfunction

endmodule

// Simplified dual-port RAM
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    (* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end
    
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule
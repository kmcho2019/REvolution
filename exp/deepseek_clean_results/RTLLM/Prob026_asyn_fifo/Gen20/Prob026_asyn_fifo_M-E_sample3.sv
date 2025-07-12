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
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory interface
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr_local[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_local[ADDR_WIDTH-1:0];
    
    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );
    
    // Write domain registers
    reg [PTR_WIDTH-1:0] wptr_local;      // Local write pointer
    reg [PTR_WIDTH-1:0] rptr_mirror;     // Mirrored read pointer
    reg [1:0] wphase;                    // Write phase indicator
    
    // Read domain registers
    reg [PTR_WIDTH-1:0] rptr_local;      // Local read pointer
    reg [PTR_WIDTH-1:0] wptr_mirror;     // Mirrored write pointer
    reg [1:0] rphase;                    // Read phase indicator
    
    // Synchronization stages
    reg [PTR_WIDTH-1:0] wptr_sync [0:1]; // Write pointer sync chain
    reg [PTR_WIDTH-1:0] rptr_sync [0:1]; // Read pointer sync chain
    
    // Pointer update logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_local <= 0;
            wphase <= 0;
        end else if (wenc) begin
            wptr_local <= wptr_local + 1;
            wphase <= ~wphase; // Toggle phase on each write
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_local <= 0;
            rphase <= 0;
        end else if (renc) begin
            rptr_local <= rptr_local + 1;
            rphase <= ~rphase; // Toggle phase on each read
        end
    end
    
    // Pointer mirroring and synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rptr_mirror <= 0;
        end else begin
            rptr_sync[0] <= rptr_local;
            rptr_sync[1] <= rptr_sync[0];
            // Update mirror only when phase changes
            if (rptr_sync[1][PTR_WIDTH] != rptr_sync[0][PTR_WIDTH])
                rptr_mirror <= rptr_sync[1];
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wptr_mirror <= 0;
        end else begin
            wptr_sync[0] <= wptr_local;
            wptr_sync[1] <= wptr_sync[0];
            // Update mirror only when phase changes
            if (wptr_sync[1][PTR_WIDTH] != wptr_sync[0][PTR_WIDTH])
                wptr_mirror <= wptr_sync[1];
        end
    end
    
    // Full/empty detection using phase comparison
    always @(*) begin
        // Full when write pointer laps read pointer (phase difference = 2)
        wfull = (wptr_local - rptr_mirror) >= DEPTH;
        // Empty when pointers are equal and in same phase
        rempty = (rptr_local == wptr_mirror) && (rphase == wptr_mirror[PTR_WIDTH]);
    end

endmodule

// Dual-port RAM module (same as previous implementation)
module dual_port_ram #(
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule
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
    wire [WIDTH-1:0] rdata_ram;
    dual_port_ram ram(
        .wclk(wclk), 
        .wenc(wenc), 
        .waddr(waddr), 
        .wdata(wdata), 
        .rclk(rclk), 
        .renc(ren), 
        .raddr(raddr), 
        .rdata(rdata_ram)
    );

    // Write Pointer Management
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [3:0] wgray;
    always @(posedge wclk or negedge wrstn)
    begin
        if (~wrstn) begin
            wptr <= 0;
            wgray <= 0;
        end
        else if (winc) begin
            wptr <= (wptr + 1) % DEPTH;
            wgray <= {wgray[2:0], wgray[3] ^ wgray[2]};
        end
    end

    // Read Pointer Management
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [3:0] rgray;
    always @(posedge rclk or negedge rrstn)
    begin
        if (~rrstn) begin
            rptr <= 0;
            rgray <= 0;
        end
        else if (rinc) begin
            rptr <= (rptr + 1) % DEPTH;
            rgray <= {rgray[2:0], rgray[3] ^ rgray[2]};
        end
    end

    // Two-stage Synchronizer for Read Pointer
    reg [3:0] rgray_sync1;
    reg [3:0] rgray_sync2;
    always @(posedge wclk)
    begin
        rgray_sync1 <= rgray;
    end
    always @(posedge wclk)
    begin
        rgray_sync2 <= rgray_sync1;
    end

    // Two-stage Synchronizer for Write Pointer
    reg [3:0] wgray_sync1;
    reg [3:0] wgray_sync2;
    always @(posedge rclk)
    begin
        wgray_sync1 <= wgray;
    end
    always @(posedge rclk)
    begin
        wgray_sync2 <= wgray_sync1;
    end

    // Full and Empty Conditions
    assign wfull = (wgray_sync2[3:2] == ~rgray[3:2]) && (wgray_sync2[1:0] == rgray[1:0]);
    assign rempty = (wgray == rgray);

    // Write Enable
    assign wenc = winc;

    // Read Enable
    assign ren = rinc;

    // Write Address
    assign waddr = wptr[3:0];

    // Read Address
    assign raddr = rptr[3:0];

    // Output Assignment
    assign rdata = rdata_ram;

endmodule

module dual_port_ram(
    input  wclk, 
    input  wenc, 
    input  [$clog2(DEPTH)-1:0] waddr, 
    input  [WIDTH-1:0] wdata, 
    input  rclk, 
    input  renc, 
    input  [$clog2(DEPTH)-1:0] raddr, 
    output reg [WIDTH-1:0] rdata
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [WIDTH-1:0] ram[DEPTH-1:0];
    reg [WIDTH-1:0] rdata_reg;

    always @(posedge wclk)
    begin
        if (wenc) begin
            ram[waddr] <= wdata;
        end
    end

    always @(posedge rclk)
    begin
        if (renc) begin
            rdata_reg <= ram[raddr];
        end
    end

    assign rdata = rdata_reg;

endmodule
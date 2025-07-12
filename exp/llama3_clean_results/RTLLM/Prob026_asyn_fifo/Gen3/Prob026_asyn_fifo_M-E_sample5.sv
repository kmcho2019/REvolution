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

    // Single-port RAM
    reg [WIDTH-1:0] ram[DEPTH-1:0];
    reg [WIDTH-1:0] rdata_reg;

    // Write Pointer Management Unit
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [WIDTH-1:0] wptr_sync;

    // Read Pointer Management Unit
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [WIDTH-1:0] rptr_sync;

    // Handshake Mechanism
    reg wreq;
    reg rack;

    // Full and Empty Conditions
    reg wfull_reg;
    reg rempty_reg;

    // Write Pointer Increment
    always @(posedge wclk or negedge wrstn)
    begin
        if (~wrstn) begin
            wptr <= 0;
        end
        else if (winc) begin
            wptr <= (wptr + 1) % DEPTH;
            wreq <= 1;
        end
        else begin
            wreq <= 0;
        end
    end

    // Read Pointer Increment
    always @(posedge rclk or negedge rrstn)
    begin
        if (~rrstn) begin
            rptr <= 0;
        end
        else if (rinc && !wfull_reg) begin
            rptr <= (rptr + 1) % DEPTH;
            rdata_reg <= ram[rptr];
            rack <= 1;
        end
        else begin
            rack <= 0;
        end
    end

    // Handshake Mechanism
    always @(posedge rclk)
    begin
        if (wreq) begin
            wptr_sync <= wptr;
        end
    end

    always @(posedge wclk)
    begin
        if (rack) begin
            rptr_sync <= rptr;
        end
    end

    // Full and Empty Conditions
    always @(*)
    begin
        if (wptr_sync == (rptr_sync + 1) % DEPTH) begin
            wfull_reg <= 1;
        end
        else begin
            wfull_reg <= 0;
        end

        if (rptr_sync == wptr_sync) begin
            rempty_reg <= 1;
        end
        else begin
            rempty_reg <= 0;
        end
    end

    // Output Assignments
    assign wfull = wfull_reg;
    assign rempty = rempty_reg;
    assign rdata = rdata_reg;

    // Write Operation
    always @(posedge wclk)
    begin
        if (winc && !wfull_reg) begin
            ram[wptr] <= wdata;
        end
    end

endmodule
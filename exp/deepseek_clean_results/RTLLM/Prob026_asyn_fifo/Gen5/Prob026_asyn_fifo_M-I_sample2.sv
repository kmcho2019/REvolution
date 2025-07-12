module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter OUTPUT_REG = 1  // Enable output register for better timing
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

    // Validate DEPTH is power of 2
    initial if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM implementation with power optimization
    (* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Write port with clock gating
    always @(posedge wclk) begin
        if (wen) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port with optional output register
    generate
        if (OUTPUT_REG) begin
            reg [WIDTH-1:0] rdata_reg, rdata_out;
            always @(posedge rclk) begin
                if (!rrstn) begin
                    rdata_reg <= 0;
                    rdata_out <= 0;
                end else begin
                    if (ren) rdata_reg <= mem[raddr];
                    rdata_out <= rdata_reg;
                end
            end
            assign rdata = rdata_out;
        end else begin
            reg [WIDTH-1:0] rdata_reg;
            always @(posedge rclk) begin
                if (ren) rdata_reg <= mem[raddr];
            end
            assign rdata = rdata_reg;
        end
    endgenerate

    // Write pointer logic with pre-computed Gray code
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (wen ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_bin_next ^ (wptr_bin_next >> 1);
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Read pointer logic with pre-computed Gray code
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (ren ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_bin_next ^ (rptr_bin_next >> 1);
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Synchronizers with pipeline registers
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Optimized full/empty detection
    wire full_condition = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                       rptr_sync2[PTR_WIDTH-3:0]});
    wire empty_condition = (rptr_gray == wptr_sync2);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= full_condition;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= empty_condition;
        end
    end

    // Error checking (optional)
    always @(posedge wclk) begin
        if (winc && wfull) 
            $warning("Write attempted when FIFO is full");
    end

    always @(posedge rclk) begin
        if (rinc && rempty) 
            $warning("Read attempted when FIFO is empty");
    end

endmodule
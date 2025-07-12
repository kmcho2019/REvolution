module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SEGMENTS = 4  // Number of virtual segments (must divide DEPTH)
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

    // Validate parameters
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
        if ((DEPTH % SEGMENTS) != 0) begin
            $error("DEPTH must be divisible by SEGMENTS");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam SEG_ADDR_WIDTH = $clog2(DEPTH/SEGMENTS);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    localparam PARITY_WIDTH = 2;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
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

    // Segment pointers
    typedef struct packed {
        logic [SEG_ADDR_WIDTH:0] bin;
        logic [SEG_ADDR_WIDTH:0] gray;
        logic [PARITY_WIDTH-1:0] parity;
    } seg_ptr_t;

    seg_ptr_t [SEGMENTS-1:0] wptrs, rptrs;
    seg_ptr_t [SEGMENTS-1:0] wptrs_sync [0:1], rptrs_sync [0:1];

    // Predictive flow control
    reg [1:0] wpred_state, rpred_state;
    reg [3:0] wpred_count, rpred_count;

    // Clock skew measurement
    reg [15:0] skew_counter;
    reg [1:0] skew_direction;

    // Write domain logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (int i=0; i<SEGMENTS; i++) begin
                wptrs[i].bin <= 0;
                wptrs[i].gray <= 0;
                wptrs[i].parity <= 0;
            end
            wpred_state <= 0;
            wpred_count <= 0;
        end else if (wen) begin
            // Update active segment pointer
            int active_seg = wptrs[0].bin[SEG_ADDR_WIDTH:SEG_ADDR_WIDTH-1];
            wptrs[active_seg].bin <= wptrs[active_seg].bin + 1;
            wptrs[active_seg].gray <= (wptrs[active_seg].bin + 1) ^ ((wptrs[active_seg].bin + 1) >> 1);
            wptrs[active_seg].parity <= ^{wptrs[active_seg].bin + 1, (wptrs[active_seg].bin + 1) >> 1};

            // Predictive flow control
            if (wpred_count > (DEPTH/SEGMENTS)*3/4)
                wpred_state <= 2'b10; // Approaching full
            else if (wpred_count < (DEPTH/SEGMENTS)/4)
                wpred_state <= 2'b01; // Approaching empty
            else
                wpred_state <= 2'b00; // Normal
            
            wpred_count <= wpred_count + 1;
        end
    end

    // Read domain logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (int i=0; i<SEGMENTS; i++) begin
                rptrs[i].bin <= 0;
                rptrs[i].gray <= 0;
                rptrs[i].parity <= 0;
            end
            rpred_state <= 0;
            rpred_count <= 0;
        end else if (ren) begin
            // Update active segment pointer
            int active_seg = rptrs[0].bin[SEG_ADDR_WIDTH:SEG_ADDR_WIDTH-1];
            rptrs[active_seg].bin <= rptrs[active_seg].bin + 1;
            rptrs[active_seg].gray <= (rptrs[active_seg].bin + 1) ^ ((rptrs[active_seg].bin + 1) >> 1);
            rptrs[active_seg].parity <= ^{rptrs[active_seg].bin + 1, (rptrs[active_seg].bin + 1) >> 1};

            // Predictive flow control
            if (rpred_count > (DEPTH/SEGMENTS)*3/4)
                rpred_state <= 2'b10; // Approaching full
            else if (rpred_count < (DEPTH/SEGMENTS)/4)
                rpred_state <= 2'b01; // Approaching empty
            else
                rpred_state <= 2'b00; // Normal
            
            rpred_count <= rpred_count + 1;
        end
    end

    // Segment pointer synchronization
    always @(posedge wclk) begin
        rptrs_sync[0] <= rptrs;
        rptrs_sync[1] <= rptrs_sync[0];
    end

    always @(posedge rclk) begin
        wptrs_sync[0] <= wptrs;
        wptrs_sync[1] <= wptrs_sync[0];
    end

    // Error detection and correction
    function automatic seg_ptr_t correct_ptr(seg_ptr_t ptr);
        seg_ptr_t corrected;
        logic [PARITY_WIDTH-1:0] calc_parity;
        
        corrected = ptr;
        calc_parity = ^{ptr.gray, ptr.gray >> 1};
        
        if (calc_parity != ptr.parity) begin
            // Simple error correction - revert to previous value
            corrected = ptr; // In real implementation would have history buffer
        end
        return corrected;
    endfunction

    // Full/empty detection
    always @(*) begin
        // Check all segments
        wfull = 1;
        rempty = 1;
        
        for (int i=0; i<SEGMENTS; i++) begin
            seg_ptr_t rptr_corrected = correct_ptr(rptrs_sync[1][i]);
            seg_ptr_t wptr_corrected = correct_ptr(wptrs_sync[1][i]);
            
            // Full when all segments are full
            wfull = wfull && (wptrs[i].gray == {~rptr_corrected.gray[SEG_ADDR_WIDTH:SEG_ADDR_WIDTH-1], 
                                              rptr_corrected.gray[SEG_ADDR_WIDTH-2:0]});
            
            // Empty when all segments are empty
            rempty = rempty && (rptrs[i].gray == wptr_corrected.gray);
        end
    end

    // Address generation
    assign waddr = {wptrs[0].bin[SEG_ADDR_WIDTH-1:0], wptrs[0].bin[SEG_ADDR_WIDTH+:ADDR_WIDTH-SEG_ADDR_WIDTH]};
    assign raddr = {rptrs[0].bin[SEG_ADDR_WIDTH-1:0], rptrs[0].bin[SEG_ADDR_WIDTH+:ADDR_WIDTH-SEG_ADDR_WIDTH]};

    // Clock skew measurement
    always @(posedge wclk) begin
        if (wptrs[0].gray != wptrs_sync[1][0].gray)
            skew_counter <= skew_counter + 1;
    end

    always @(posedge rclk) begin
        if (rptrs[0].gray != rptrs_sync[1][0].gray) begin
            if (skew_counter > 0) begin
                skew_direction <= (skew_counter[15]) ? 2'b01 : 2'b10;
                skew_counter <= 0;
            end
        end
    end
endmodule

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

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];

endmodule
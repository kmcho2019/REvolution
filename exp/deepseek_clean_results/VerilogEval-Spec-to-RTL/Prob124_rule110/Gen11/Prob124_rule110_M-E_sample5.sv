module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Segment the 512-bit array into 64 segments of 8 bits each
    localparam SEGMENTS = 64;
    localparam SEG_WIDTH = 8;
    
    // Pipeline registers
    reg [511:0] stage1_q;
    reg [511:0] stage2_q;
    
    // ROM implementation of Rule 110 (8 entries)
    reg [7:0] rule110_rom [0:7];
    initial begin
        rule110_rom[3'b111] = 0;
        rule110_rom[3'b110] = 1;
        rule110_rom[3'b101] = 1;
        rule110_rom[3'b100] = 0;
        rule110_rom[3'b011] = 1;
        rule110_rom[3'b010] = 1;
        rule110_rom[3'b001] = 1;
        rule110_rom[3'b000] = 0;
    end

    // Stage 1: Segment processing
    always @(posedge clk) begin
        if (load) begin
            stage1_q <= data;
        end else begin
            // Process each segment independently
            for (integer seg = 0; seg < SEGMENTS; seg = seg + 1) begin
                integer base = seg * SEG_WIDTH;
                
                // Handle left boundary (segment's left neighbor)
                wire left_bound = (seg == SEGMENTS-1) ? 1'b0 : q[base + SEG_WIDTH];
                
                // Handle right boundary (segment's right neighbor)
                wire right_bound = (seg == 0) ? 1'b0 : q[base - 1];
                
                // Process each bit in the segment
                for (integer bit = 0; bit < SEG_WIDTH; bit = bit + 1) begin
                    integer pos = base + bit;
                    
                    // Get neighbors with segment boundary handling
                    wire left = (bit == SEG_WIDTH-1) ? left_bound : q[pos+1];
                    wire center = q[pos];
                    wire right = (bit == 0) ? right_bound : q[pos-1];
                    
                    // Lookup next state from ROM
                    stage1_q[pos] <= rule110_rom[{left, center, right}];
                end
            end
        end
    end

    // Stage 2: Final output (simple pipeline register)
    always @(posedge clk) begin
        stage2_q <= stage1_q;
    end

    assign q = stage2_q;

endmodule
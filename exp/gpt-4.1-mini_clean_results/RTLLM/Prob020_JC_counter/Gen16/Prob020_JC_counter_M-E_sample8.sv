module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    // Internal signals for the 16 4-bit segments
    reg [3:0] jc_segments [15:0];
    integer i;

    // On reset, clear all segments
    // On clock, update each segment based on the previous segment's MSB
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 16; i = i + 1) begin
                jc_segments[i] <= 4'b0000;
            end
            Q <= 64'b0;
        end else begin
            // Temporary register to hold next values
            reg [3:0] next_segments [15:0];
            // For segment 0, the new MSB depends on the LSB of segment 0 (self-contained)
            next_segments[0] = {~jc_segments[0][0], jc_segments[0][3:1]};
            // For other segments, new MSB depends on LSB of previous segment to maintain chain
            for (i = 1; i < 16; i = i + 1) begin
                // Determine if LSB of previous segment is 0 or 1 to decide shift-in bit
                if (jc_segments[i-1][0] == 1'b0)
                    next_segments[i] = {1'b1, jc_segments[i][3:1]};
                else
                    next_segments[i] = {1'b0, jc_segments[i][3:1]};
            end

            // Update all segments simultaneously
            for (i = 0; i < 16; i = i + 1) begin
                jc_segments[i] <= next_segments[i];
            end

            // Concatenate all 16 4-bit segments into the 64-bit output Q, segment 15 as MSB
            Q <= {jc_segments[15], jc_segments[14], jc_segments[13], jc_segments[12],
                  jc_segments[11], jc_segments[10], jc_segments[9],  jc_segments[8],
                  jc_segments[7],  jc_segments[6],  jc_segments[5],  jc_segments[4],
                  jc_segments[3],  jc_segments[2],  jc_segments[1],  jc_segments[0]};
        end
    end

endmodule
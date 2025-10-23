module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);
    reg [3:0] ring;      // One-hot ring counter (4 states)
    reg [1:0] cycle;     // 2-bit cycle counter (counts number of ring rotations)

    // On reset: both counters zeroed, which corresponds to q = 0
    // Initialize ring to 1 (one-hot) so we can track rotation easily
    always @(posedge clk) begin
        if (reset) begin
            ring <= 4'b0001; // start with LSB set
            cycle <= 2'b00;
        end else begin
            // Rotate ring left by 1 (one-hot rotate)
            ring <= {ring[2:0], ring[3]};
            // If ring has completed a full cycle (LSB is back to 1), increment cycle counter
            if ({ring[2:0], ring[3]} == 4'b0001) begin
                cycle <= cycle + 1;
            end
        end
    end

    // Encode one-hot ring and cycle counters into a 4-bit binary count
    always @(*) begin
        // Determine ring index from one-hot (0..3)
        integer i;
        reg [1:0] ring_index;
        ring_index = 0;
        for (i=0; i<4; i=i+1) begin
            if (ring[i]) ring_index = i[1:0];
        end
        // q = cycle * 4 + ring_index
        q = {cycle, 2'b00} + {2'b00, ring_index};
    end
endmodule
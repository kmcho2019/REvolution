module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    // Internal registers for 8 segments of 8 bits each
    reg [7:0] segments [7:0];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all segments to zero
            for (i = 0; i < 8; i = i + 1) begin
                segments[i] <= 8'b0;
            end
            Q <= 64'b0;
        end else begin
            // Temporary variable to hold new segments
            reg [7:0] next_segments [7:0];

            // Calculate next state of first segment
            // MSB gets inverted Q[0]
            next_segments[0] = { ~Q[0], segments[0][7:1] };

            // Calculate next states of subsequent segments
            // Each gets MSB from previous segment's LSB
            for (i = 1; i < 8; i = i + 1) begin
                next_segments[i] = { segments[i-1][0], segments[i][7:1] };
            end

            // Update segments
            for (i = 0; i < 8; i = i + 1) begin
                segments[i] <= next_segments[i];
            end

            // Concatenate all segments to form the 64-bit Q output
            Q <= { segments[7], segments[6], segments[5], segments[4],
                   segments[3], segments[2], segments[1], segments[0] };
        end
    end

endmodule
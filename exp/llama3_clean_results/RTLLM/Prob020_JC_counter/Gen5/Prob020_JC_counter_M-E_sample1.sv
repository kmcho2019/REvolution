module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Divide the 64-bit register into 8 segments of 8 bits each
reg [7:0] segment [7:0];

// Initialize the segments
integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all segments to 0
        for (i = 0; i < 8; i++) begin
            segment[i] <= 8'd0;
        end
    end else begin
        // Update each segment based on the least significant bit of the preceding segment
        for (i = 0; i < 8; i++) begin
            if (i == 0) begin
                // For the first segment, check the least significant bit of the last segment
                if (segment[7][0] == 1'b0) begin
                    segment[0] <= {1'b1, segment[0][7:1]};
                end else begin
                    segment[0] <= {1'b0, segment[0][7:1]};
                end
            end else begin
                // For other segments, check the least significant bit of the preceding segment
                if (segment[i-1][0] == 1'b0) begin
                    segment[i] <= {1'b1, segment[i][7:1]};
                end else begin
                    segment[i] <= {1'b0, segment[i][7:1]};
                end
            end
        end
    end
end

// Combine the segments to form the 64-bit output Q
always @(*) begin
    Q = {segment[7], segment[6], segment[5], segment[4], segment[3], segment[2], segment[1], segment[0]};
end

endmodule
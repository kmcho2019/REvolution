module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Internal signals for segment control
wire [7:0] segment_update [7:0];

// Generate update logic for each 8-bit segment
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : SEGMENT
        // First segment uses its own LSB
        if (i == 0) begin
            assign segment_update[i] = {~Q[0], Q[7:1]};
        end
        // Other segments use previous segment's LSB
        else begin
            assign segment_update[i] = {~Q[(i*8)], Q[(i*8)+7:(i*8)+1]};
        end
    end
endgenerate

// Update all segments in parallel
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end
    else begin
        Q <= {segment_update[7], segment_update[6], segment_update[5], segment_update[4],
              segment_update[3], segment_update[2], segment_update[1], segment_update[0]};
    end
end

endmodule
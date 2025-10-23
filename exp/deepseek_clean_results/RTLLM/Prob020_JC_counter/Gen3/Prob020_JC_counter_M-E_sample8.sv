module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

parameter WIDTH = 64;
parameter SEGMENT_SIZE = 8;
localparam NUM_SEGMENTS = WIDTH/SEGMENT_SIZE;

genvar i;
generate
    for (i = 0; i < NUM_SEGMENTS; i = i + 1) begin : segment
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                Q[i*SEGMENT_SIZE +: SEGMENT_SIZE] <= {SEGMENT_SIZE{1'b0}};
            end else begin
                if (i == 0) begin
                    // First segment uses inverted LSB of last segment
                    Q[i*SEGMENT_SIZE +: SEGMENT_SIZE] <= 
                        {~Q[WIDTH-1], Q[i*SEGMENT_SIZE + SEGMENT_SIZE-1:i*SEGMENT_SIZE + 1]};
                end else begin
                    // Other segments use MSB from previous segment
                    Q[i*SEGMENT_SIZE +: SEGMENT_SIZE] <= 
                        {Q[(i-1)*SEGMENT_SIZE + SEGMENT_SIZE-1], 
                         Q[i*SEGMENT_SIZE + SEGMENT_SIZE-1:i*SEGMENT_SIZE + 1]};
                end
            end
        end
    end
endgenerate

endmodule
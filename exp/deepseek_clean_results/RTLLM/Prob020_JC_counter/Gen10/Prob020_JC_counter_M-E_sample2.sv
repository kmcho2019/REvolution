module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Segment control signals
wire [7:0] segment_boundary;
wire [7:0] segment_direction;

// Generate boundary detection for each 8-bit segment
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : SEGMENTS
        // Detect when segment reaches all 1s or all 0s
        assign segment_boundary[i] = (Q[i*8 +: 8] == 8'hFF) || (Q[i*8 +: 8] == 8'h00);
        
        // Track direction for each segment (0 = counting up, 1 = counting down)
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                segment_direction[i] <= 0;
            end else if (segment_boundary[i]) begin
                segment_direction[i] <= ~segment_direction[i];
            end
        end
        
        // Segment Johnson counter logic
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                Q[i*8 +: 8] <= 8'h00;
            end else begin
                if (segment_direction[i]) begin
                    // Counting down (shift right with 0)
                    Q[i*8 +: 8] <= {1'b0, Q[i*8 +: 8][7:1]};
                end else begin
                    // Counting up (shift right with 1)
                    Q[i*8 +: 8] <= {1'b1, Q[i*8 +: 8][7:1]};
                end
            end
        end
    end
endgenerate

endmodule
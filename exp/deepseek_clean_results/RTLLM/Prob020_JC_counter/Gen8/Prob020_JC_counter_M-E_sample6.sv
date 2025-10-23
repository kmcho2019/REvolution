module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Internal segments
wire [7:0] segment_in [7:0];
wire [7:0] segment_out [7:0];

// Generate 8 segments of 8 bits each
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : SEGMENT
        // Connect segments in a ring
        assign segment_in[i] = (i == 0) ? {~segment_out[7][0], segment_out[i][7:1]} : 
                                         {~segment_out[i-1][0], segment_out[i][7:1]};
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                segment_out[i] <= 8'b0;
            end else begin
                segment_out[i] <= segment_in[i];
            end
        end
    end
endgenerate

// Combine all segments
always @(*) begin
    Q = {segment_out[7], segment_out[6], segment_out[5], segment_out[4],
         segment_out[3], segment_out[2], segment_out[1], segment_out[0]};
end

endmodule
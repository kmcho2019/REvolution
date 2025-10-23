module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Parameters for segment configuration
parameter SEG_WIDTH = 4;
parameter NUM_SEG = 4;
localparam TOTAL_WIDTH = SEG_WIDTH * NUM_SEG;

// Segment registers with Gray encoding
reg [SEG_WIDTH-1:0] seg [0:NUM_SEG-1];
reg [TOTAL_WIDTH-1:0] gray_count;

// Segment activation flags
wire [NUM_SEG-1:0] seg_active;

// Binary to Gray conversion function
function [TOTAL_WIDTH-1:0] bin2gray;
    input [TOTAL_WIDTH-1:0] bin;
    begin
        bin2gray = bin ^ (bin >> 1);
    end
endfunction

// Generate segment carry logic
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin: SEG_LOOP
        // Carry out from current segment
        wire seg_carry_out = up_down ? &seg[i] : ~|seg[i];
        
        // Segment is active if all lower segments are carrying
        assign seg_active[i] = (i == 0) ? 1'b1 : 
                             (seg_active[i-1] && 
                              (up_down ? &seg[i-1] : ~|seg[i-1]));
        
        always @(posedge clk) begin
            if (reset) begin
                seg[i] <= {SEG_WIDTH{1'b0}};
            end else if (seg_active[i]) begin
                seg[i] <= up_down ? seg[i] + 1'b1 : seg[i] - 1'b1;
            end
        end
    end
endgenerate

// Combine segments and convert to Gray code
always @(*) begin
    count = {seg[3], seg[2], seg[1], seg[0]};
    gray_count = bin2gray(count);
end

endmodule
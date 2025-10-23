module up_down_counter #(
    parameter WIDTH = 16,
    parameter SEG_WIDTH = 4
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

localparam NUM_SEG = WIDTH / SEG_WIDTH;

// Segment registers
reg [SEG_WIDTH-1:0] seg [0:NUM_SEG-1];
wire [NUM_SEG-1:0] seg_carry;
wire [NUM_SEG-1:0] seg_enable;

// Combinational logic for segment operations
genvar i;
generate
    // Generate segment carry/borrow signals
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEG_LOGIC
        assign seg_carry[i] = up_down ? (&seg[i]) : (seg[i] == {SEG_WIDTH{1'b0}});
        assign seg_enable[i] = (i == 0) ? 1'b1 : &seg_carry[i-1:0];
    end

    // Generate next segment values
    wire [SEG_WIDTH-1:0] next_seg [0:NUM_SEG-1];
    for (i = 0; i < NUM_SEG; i = i + 1) begin : NEXT_SEG
        assign next_seg[i] = reset ? {SEG_WIDTH{1'b0}} :
                           (seg_enable[i] ? 
                               (up_down ? seg[i] + 1'b1 : seg[i] - 1'b1) :
                               seg[i]);
    end
endgenerate

// Sequential logic for segments
integer j;
always @(posedge clk) begin
    for (j = 0; j < NUM_SEG; j = j + 1) begin
        seg[j] <= next_seg[j];
    end
end

// Combine segments into output
always @(*) begin
    for (j = 0; j < NUM_SEG; j = j + 1) begin
        count[j*SEG_WIDTH +: SEG_WIDTH] = seg[j];
    end
end

endmodule
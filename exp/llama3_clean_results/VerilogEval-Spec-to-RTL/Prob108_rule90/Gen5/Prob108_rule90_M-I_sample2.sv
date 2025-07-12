module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Segment size for parallelizing XOR operations
localparam SEG_SIZE = 64;
localparam NUM_SEGS = 512 / SEG_SIZE;

reg [SEG_SIZE-1:0] seg_left [NUM_SEGS-1:0];
reg [SEG_SIZE-1:0] seg_right [NUM_SEGS-1:0];
reg [SEG_SIZE-1:0] seg_result [NUM_SEGS-1:0];

always @(posedge clk) begin
    if (load) begin
        q_reg = data;
    end else begin
        // Compute next state using XOR of left and right neighbors
        // Divide into segments for parallel computation
        for (int i = 0; i < NUM_SEGS; i++) begin
            if (i == 0) begin
                // Handle left boundary
                seg_left[i] = {SEG_SIZE{1'b0}};
                seg_right[i] = q_reg[(i+1)*SEG_SIZE-1:i*SEG_SIZE];
            end else if (i == NUM_SEGS - 1) begin
                // Handle right boundary
                seg_left[i] = q_reg[(i-1)*SEG_SIZE+SEG_SIZE-1:(i-1)*SEG_SIZE];
                seg_right[i] = {SEG_SIZE{1'b0}};
            end else begin
                seg_left[i] = q_reg[(i-1)*SEG_SIZE+SEG_SIZE-1:(i-1)*SEG_SIZE];
                seg_right[i] = q_reg[(i+1)*SEG_SIZE-1:i*SEG_SIZE];
            end
            // Compute XOR of left and right segments
            seg_result[i] = seg_left[i] ^ seg_right[i];
        end
        // Combine segment results to form next state
        for (int i = 0; i < NUM_SEGS; i++) begin
            q_reg[(i+1)*SEG_SIZE-1:i*SEG_SIZE] = seg_result[i];
        end
    end
end

assign q = q_reg;

endmodule
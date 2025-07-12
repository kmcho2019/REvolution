module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers (8 stages of 64 bits each)
    reg [511:0] stage [0:7];
    integer i;

    // Shift registers for neighbor information
    reg [63:0] left_neighbor [0:7];
    reg [63:0] right_neighbor [0:7];

    // Combinational next state for current pipeline stage
    wire [63:0] next_stage;

    // Generate next state for current 64-bit chunk
    genvar j;
    generate
        for (j = 0; j < 64; j = j + 1) begin : rule110_pipe
            // Get neighbors from shift registers
            wire left = (j == 63) ? left_neighbor[0][0] : stage[0][j+1];
            wire center = stage[0][j];
            wire right = (j == 0) ? right_neighbor[0][63] : stage[0][j-1];

            // Optimized Rule 110 logic
            assign next_stage[j] = (left & center & ~right) |  // 110
                                 (left & ~center & right) |   // 101
                                 (~left & center) |           // 011 or 010
                                 (~left & right);             // 001
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            // Load new data and initialize pipeline
            stage[0] <= data;
            for (i = 1; i < 8; i = i + 1) begin
                stage[i] <= 0;
            end
            // Initialize neighbor registers
            left_neighbor[0] <= 0;  // Left boundary
            right_neighbor[0] <= 0;  // Right boundary
        end else begin
            // Pipeline shift operation
            for (i = 0; i < 7; i = i + 1) begin
                stage[i+1] <= stage[i];
                left_neighbor[i+1] <= left_neighbor[i];
                right_neighbor[i+1] <= right_neighbor[i];
            end

            // Process current stage and update neighbors
            stage[0] <= next_stage;
            left_neighbor[0] <= stage[0][63:0];  // Capture left neighbor for next chunk
            right_neighbor[0] <= stage[0][511:448];  // Capture right neighbor for next chunk
        end

        // Output is the last pipeline stage
        q <= stage[7];
    end

endmodule
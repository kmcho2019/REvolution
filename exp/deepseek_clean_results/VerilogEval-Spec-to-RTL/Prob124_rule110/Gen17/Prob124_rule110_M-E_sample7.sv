module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipelined processing parameters
    parameter PIPELINES = 4;
    parameter BITS_PER_PIPE = 128;
    
    // Shift registers for each pipeline
    reg [BITS_PER_PIPE+1:0] shift_reg [0:PIPELINES-1]; // +2 for boundary bits
    
    // Next state calculation logic
    function automatic rule110;
        input left, center, right;
        begin
            // Optimized Rule 110 logic
            rule110 = (center ^ (left & right)) | (~left & right);
        end
    endfunction
    
    integer i, j;
    always @(posedge clk) begin
        if (load) begin
            // Load data into pipelines
            for (i = 0; i < PIPELINES; i = i + 1) begin
                shift_reg[i] <= {1'b0, data[i*BITS_PER_PIPE +: BITS_PER_PIPE], 1'b0};
            end
            q <= data;
        end else begin
            // Process each pipeline
            for (i = 0; i < PIPELINES; i = i + 1) begin
                // Shift and process
                for (j = 0; j < BITS_PER_PIPE; j = j + 1) begin
                    shift_reg[i][j] <= rule110(
                        shift_reg[i][j+2],
                        shift_reg[i][j+1],
                        shift_reg[i][j]
                    );
                end
                
                // Handle circular boundary
                shift_reg[i][BITS_PER_PIPE] <= rule110(
                    shift_reg[i][BITS_PER_PIPE+1],
                    shift_reg[i][BITS_PER_PIPE],
                    shift_reg[i][BITS_PER_PIPE-1]
                );
                shift_reg[i][BITS_PER_PIPE+1] <= rule110(
                    shift_reg[i][0],
                    shift_reg[i][BITS_PER_PIPE+1],
                    shift_reg[i][BITS_PER_PIPE]
                );
                
                // Update output
                q[i*BITS_PER_PIPE +: BITS_PER_PIPE] <= shift_reg[i][BITS_PER_PIPE:1];
            end
        end
    end

endmodule
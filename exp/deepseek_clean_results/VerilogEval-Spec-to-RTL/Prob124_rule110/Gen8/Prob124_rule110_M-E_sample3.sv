module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    // Pipeline registers (8 stages of 64 bits)
    reg [63:0] stage [0:7];
    reg [63:0] next_stage [0:7];
    reg [2:0] pipeline_ptr;
    
    // Boundary condition registers
    reg left_boundary, right_boundary;
    
    // Output assignment
    assign q = {stage[0], stage[1], stage[2], stage[3], 
                stage[4], stage[5], stage[6], stage[7]};
    
    integer i, j;
    
    always @(posedge clk) begin
        if (load) begin
            // Load all stages at once
            for (i = 0; i < 8; i = i + 1)
                stage[i] <= data[i*64 +: 64];
            pipeline_ptr <= 0;
            left_boundary <= 0;
            right_boundary <= 0;
        end else begin
            // Process one stage per cycle in round-robin fashion
            pipeline_ptr <= pipeline_ptr + 1;
            
            // Update boundary conditions
            left_boundary <= (pipeline_ptr == 0) ? 0 : stage[7][63];
            right_boundary <= (pipeline_ptr == 0) ? stage[0][0] : 0;
            
            // Compute next state for current stage
            for (j = 0; j < 64; j = j + 1) begin
                reg left, center, right;
                center = stage[pipeline_ptr][j];
                
                // Determine left neighbor
                if (j == 63) begin
                    left = (pipeline_ptr == 7) ? left_boundary : stage[pipeline_ptr+1][0];
                end else begin
                    left = stage[pipeline_ptr][j+1];
                end
                
                // Determine right neighbor
                if (j == 0) begin
                    right = (pipeline_ptr == 0) ? right_boundary : stage[pipeline_ptr-1][63];
                end else begin
                    right = stage[pipeline_ptr][j-1];
                end
                
                // Apply Rule 110
                case ({left, center, right})
                    3'b111, 3'b100, 3'b000: next_stage[pipeline_ptr][j] = 1'b0;
                    default: next_stage[pipeline_ptr][j] = 1'b1;
                endcase
            end
            
            // Update only the current stage
            stage[pipeline_ptr] <= next_stage[pipeline_ptr];
        end
    end

endmodule
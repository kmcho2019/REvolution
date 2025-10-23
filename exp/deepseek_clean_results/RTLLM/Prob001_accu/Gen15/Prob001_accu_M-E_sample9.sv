module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for tracking valid inputs
    reg [3:0] valid_shift = 4'b0000;
    
    // Partial sums pipeline
    reg [9:0] sum_stage1 = 10'b0;
    reg [9:0] sum_stage2 = 10'b0;
    reg [9:0] sum_stage3 = 10'b0;
    
    // Early sum prediction wires
    wire [9:0] next_stage1 = sum_stage1 + data_in;
    wire [9:0] next_stage2 = sum_stage2 + data_in;
    wire [9:0] next_stage3 = sum_stage3 + data_in;
    wire [9:0] next_output = sum_stage3 + data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            valid_shift <= 4'b0000;
            sum_stage1 <= 10'b0;
            sum_stage2 <= 10'b0;
            sum_stage3 <= 10'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            data_out <= 10'b0;
            
            if (valid_in) begin
                // Shift in new valid bit
                valid_shift <= {valid_shift[2:0], 1'b1};
                
                // Update partial sums
                sum_stage1 <= next_stage1;
                sum_stage2 <= next_stage2;
                sum_stage3 <= next_stage3;
                
                // Check if we have 4 valid inputs
                if (valid_shift[3]) begin
                    data_out <= next_output;
                    valid_out <= 1'b1;
                    
                    // Reset partial sums for next cycle
                    sum_stage1 <= 10'b0;
                    sum_stage2 <= 10'b0;
                    sum_stage3 <= 10'b0;
                end
            end
            else begin
                // Shift in 0 when no valid input
                valid_shift <= {valid_shift[2:0], 1'b0};
            end
        end
    end

endmodule
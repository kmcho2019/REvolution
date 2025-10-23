module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;          // Counts 0-3 (4 inputs)
    reg [9:0] stage1_sum;     // First stage accumulation
    reg [9:0] stage2_sum;     // Second stage accumulation

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            stage1_sum <= 10'b0;
            stage2_sum <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default valid_out to 0 unless we're outputting
            valid_out <= 1'b0;

            if (valid_in) begin
                // First stage: accumulate current input
                stage1_sum <= stage2_sum + data_in;
                
                // Second stage: pipeline the accumulation
                stage2_sum <= stage1_sum;
                
                // Counter logic
                if (count == 2'b11) begin
                    // On 4th input, output sum and reset
                    data_out <= stage1_sum;
                    valid_out <= 1'b1;
                    stage1_sum <= 10'b0;
                    stage2_sum <= 10'b0;
                    count <= 2'b00;
                end
                else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
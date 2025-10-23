module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] counter;          // Counts 0-3 (4 inputs)
    reg [8:0] sum_stage1;       // First stage sum (data_in + LSB of accumulator)
    reg [9:0] accumulator;      // Final accumulated sum
    reg [7:0] data_in_reg;      // Registered input

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'b00;
            sum_stage1 <= 9'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            data_in_reg <= 8'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;

            if (valid_in) begin
                // Register input data
                data_in_reg <= data_in;

                // First stage: Add input to LSBs of accumulator
                sum_stage1 <= {1'b0, data_in} + accumulator[7:0];

                if (counter == 2'b11) begin
                    // Second stage: Final sum with carry from first stage
                    data_out <= {accumulator[9:8] + sum_stage1[8], sum_stage1[7:0]};
                    valid_out <= 1'b1;
                    counter <= 2'b00;
                    accumulator <= 10'b0;
                end
                else begin
                    // Second stage: Update accumulator with carry
                    accumulator <= {accumulator[9:8] + sum_stage1[8], sum_stage1[7:0]};
                    counter <= counter + 1'b1;
                end
            end
        end
    end

endmodule
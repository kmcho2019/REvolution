module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] counter;          // Counts 0-3 (4 inputs)
    reg [7:0] partial_sum [0:1]; // Pipeline registers
    reg [8:0] stage1_sum;       // First stage sum (9 bits)
    reg [9:0] final_sum;        // Final accumulator (10 bits)
    wire counter_en = valid_in && (counter != 2'b11);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'b00;
            partial_sum[0] <= 8'b0;
            partial_sum[1] <= 8'b0;
            stage1_sum <= 9'b0;
            final_sum <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Pipeline stage 0
            if (valid_in) begin
                partial_sum[0] <= data_in;
                partial_sum[1] <= partial_sum[0];
            end

            // Pipeline stage 1 (carry-save style)
            stage1_sum <= {1'b0, partial_sum[1]} + {1'b0, partial_sum[0]};

            // Final accumulation stage
            if (valid_in) begin
                if (counter == 2'b11) begin
                    final_sum <= stage1_sum + data_in;
                    data_out <= stage1_sum + data_in;
                end
                else begin
                    final_sum <= final_sum + stage1_sum;
                end
            end

            // Counter and valid generation
            valid_out <= (valid_in && (counter == 2'b11));
            
            if (counter_en) begin
                counter <= counter + 1'b1;
            end
            else if (valid_in) begin
                counter <= 2'b00;
            end
        end
    end

endmodule
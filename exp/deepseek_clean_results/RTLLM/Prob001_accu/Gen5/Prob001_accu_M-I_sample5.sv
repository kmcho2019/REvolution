module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [7:0] stage1_reg;
    reg [8:0] stage2_reg;
    reg [9:0] final_sum;
    reg count_eq_3;

    // Early count comparison for better timing
    always @(*) begin
        count_eq_3 = (count == 2'b11);
    end

    // Clock-gated accumulation pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            stage1_reg <= 8'b0;
            stage2_reg <= 9'b0;
            final_sum <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                // Pipeline stage 1: First addition
                stage1_reg <= data_in;
                
                // Pipeline stage 2: Second addition
                stage2_reg <= {1'b0, stage1_reg} + data_in;
                
                // Final accumulation
                if (count_eq_3) begin
                    final_sum <= {2'b00, stage1_reg} + {1'b0, stage2_reg} + data_in;
                    data_out <= final_sum;
                    valid_out <= 1'b1;
                    count <= 2'b00;
                end
                else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
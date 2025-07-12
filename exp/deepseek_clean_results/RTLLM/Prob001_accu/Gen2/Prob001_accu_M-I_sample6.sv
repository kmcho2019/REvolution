module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;          // Counts 0-3 (4 inputs)
    reg [9:0] accumulator;    // Main accumulator
    reg [7:0] stage1_reg;     // Pipeline stage 1 register
    reg stage1_valid;         // Pipeline stage 1 valid
    wire clk_gated;           // Gated clock signal

    // Clock gating for power reduction
    assign clk_gated = clk & (valid_in | !rst_n);

    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'b0;
            stage1_reg <= 8'b0;
            stage1_valid <= 1'b0;
        end
        else begin
            // Pipeline stage 1: register input
            stage1_reg <= data_in;
            stage1_valid <= valid_in;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;

            // Pipeline stage 2: accumulation and output
            if (stage1_valid) begin
                if (count == 2'b11) begin
                    // Final accumulation and output
                    data_out <= accumulator + stage1_reg;
                    valid_out <= 1'b1;
                    accumulator <= 10'b0;
                    count <= 2'b00;
                end
                else begin
                    // Intermediate accumulation
                    accumulator <= accumulator + stage1_reg;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
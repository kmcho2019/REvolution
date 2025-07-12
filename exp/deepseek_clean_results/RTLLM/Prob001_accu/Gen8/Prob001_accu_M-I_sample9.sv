module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [7:0] data_reg [0:3];  // Store last 4 inputs
    reg [1:0] wr_ptr;          // Write pointer
    reg full_flag;             // Indicates when we have 4 samples
    wire [9:0] sum_01, sum_23, total_sum;

    // Clock gating enable
    wire cg_en = valid_in | !rst_n;

    // Calculate sums in parallel
    assign sum_01 = data_reg[0] + data_reg[1];
    assign sum_23 = data_reg[2] + data_reg[3];
    assign total_sum = sum_01 + sum_23;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 2'b0;
            full_flag <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
            // Reset data registers
            data_reg[0] <= 8'b0;
            data_reg[1] <= 8'b0;
            data_reg[2] <= 8'b0;
            data_reg[3] <= 8'b0;
        end
        else if (cg_en) begin  // Clock gating
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Store input data
                data_reg[wr_ptr] <= data_in;
                
                // Update write pointer and full flag
                if (wr_ptr == 2'd3) begin
                    wr_ptr <= 2'd0;
                    full_flag <= 1'b1;
                end
                else begin
                    wr_ptr <= wr_ptr + 1;
                    full_flag <= 1'b0;
                end
                
                // Output when we have 4 samples
                if (full_flag && wr_ptr == 2'd3) begin
                    data_out <= total_sum;
                    valid_out <= 1'b1;
                end
            end
        end
    end

endmodule
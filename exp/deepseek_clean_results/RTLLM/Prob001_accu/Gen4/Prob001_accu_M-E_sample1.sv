module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

// Shift register for input storage
reg [7:0] data_reg [0:3];
reg [1:0] wr_ptr;
reg [2:0] valid_cnt;

// Pipeline registers
reg [8:0] sum_stage1;
reg [9:0] sum_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        data_reg[0] <= 8'b0;
        data_reg[1] <= 8'b0;
        data_reg[2] <= 8'b0;
        data_reg[3] <= 8'b0;
        wr_ptr <= 2'b0;
        valid_cnt <= 3'b0;
        sum_stage1 <= 9'b0;
        sum_stage2 <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        // Input handling
        if (valid_in) begin
            // Store input in circular buffer
            data_reg[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1'b1;
            
            // Count valid inputs
            if (valid_cnt < 3'd4) begin
                valid_cnt <= valid_cnt + 1'b1;
            end
        end
        
        // Pipeline stage 1: First two additions
        sum_stage1 <= data_reg[0] + data_reg[1];
        
        // Pipeline stage 2: Second two additions and intermediate sum
        sum_stage2 <= sum_stage1 + (data_reg[2] + data_reg[3]);
        
        // Output generation (aligned with pipeline)
        if (valid_cnt >= 3'd4) begin
            data_out <= sum_stage2;
            valid_out <= 1'b1;
        end
    end
end

endmodule
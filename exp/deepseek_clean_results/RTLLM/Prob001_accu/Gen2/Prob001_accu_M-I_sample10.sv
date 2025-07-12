module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [3:0] valid_shift;  // Shift register to track last 4 valids
reg [9:0] accumulator;
reg [9:0] sum_reg;
reg valid_in_d;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_shift <= 4'b0;
        accumulator <= 10'b0;
        valid_in_d <= 1'b0;
    end
    else begin
        valid_in_d <= valid_in;
        
        if (valid_in) begin
            // Shift in new valid and accumulate
            valid_shift <= {valid_shift[2:0], 1'b1};
            accumulator <= accumulator + data_in;
        end
        else begin
            valid_shift <= {valid_shift[2:0], 1'b0};
        end

        // Clear accumulator after output generation
        if (valid_out) begin
            accumulator <= 10'b0;
            valid_shift <= 4'b0;
        end
    end
end

// Final sum calculation and output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        valid_out <= 1'b0;
        
        // Check if we've received 4 valid inputs
        if (valid_shift[3] && valid_in_d) begin
            sum_reg <= accumulator + data_in;
            valid_out <= 1'b1;
            data_out <= sum_reg;
        end
    end
end

endmodule
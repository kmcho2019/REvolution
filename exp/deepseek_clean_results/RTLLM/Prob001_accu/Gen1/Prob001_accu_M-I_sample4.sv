module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [7:0] data_reg [0:3];  // Shift register for input data
reg [2:0] valid_reg;       // Shift register for valid signals
reg [9:0] partial_sum;     // Accumulates first 3 inputs
reg [9:0] final_sum;       // Final sum register

// Clock gating control
wire accum_en = valid_in && (valid_reg != 3'b111);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        valid_reg <= 3'b0;
        partial_sum <= 10'b0;
        final_sum <= 10'b0;
        data_out <= 10'b0;
        valid_out <= 1'b0;
        data_reg[0] <= 8'b0;
        data_reg[1] <= 8'b0;
        data_reg[2] <= 8'b0;
        data_reg[3] <= 8'b0;
    end
    else begin
        // Shift register for valid inputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Shift data through register
            data_reg[3] <= data_reg[2];
            data_reg[2] <= data_reg[1];
            data_reg[1] <= data_reg[0];
            data_reg[0] <= data_in;
            
            // Shift valid indicator
            valid_reg <= {valid_reg[1:0], 1'b1};
            
            // Accumulate first 3 inputs
            if (accum_en) begin
                if (valid_reg == 3'b0) begin
                    partial_sum <= data_in;
                end
                else begin
                    partial_sum <= partial_sum + data_in;
                end
            end
            
            // Final addition when 4th input arrives
            if (valid_reg == 3'b111) begin
                final_sum <= partial_sum + data_in;
                data_out <= final_sum;
                valid_out <= 1'b1;
                valid_reg <= 3'b0;
                partial_sum <= 10'b0;
            end
        end
    end
end

endmodule
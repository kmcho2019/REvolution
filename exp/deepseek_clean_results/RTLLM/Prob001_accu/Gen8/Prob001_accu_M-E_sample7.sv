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
    reg [3:0] valid_reg;  // Tracks which positions have valid data
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all registers
            valid_reg <= 4'b0000;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            for (integer i = 0; i < 4; i = i+1)
                data_reg[i] <= 8'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Shift in new data
                for (integer i = 3; i > 0; i = i-1) begin
                    data_reg[i] <= data_reg[i-1];
                end
                data_reg[0] <= data_in;
                
                // Update valid bits
                valid_reg <= {valid_reg[2:0], 1'b1};
                
                // Check if we have 4 valid inputs
                if (valid_reg[2:0] == 3'b111) begin
                    // Parallel addition of all 4 values
                    data_out <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                    valid_out <= 1'b1;
                    
                    // Reset for next group
                    valid_reg <= 4'b0000;
                end
            end
        end
    end

endmodule
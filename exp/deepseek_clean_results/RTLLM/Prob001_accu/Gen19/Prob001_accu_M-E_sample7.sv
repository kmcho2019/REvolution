module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for last 4 inputs
    reg [7:0] data_reg [0:3];
    
    // Counter for valid inputs (0-3)
    reg [1:0] count;
    
    // Parallel computation of all possible sums
    wire [9:0] sum1 = data_reg[0];
    wire [9:0] sum2 = data_reg[0] + data_reg[1];
    wire [9:0] sum3 = data_reg[0] + data_reg[1] + data_reg[2];
    wire [9:0] sum4 = data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data_reg[0] <= 8'b0;
            data_reg[1] <= 8'b0;
            data_reg[2] <= 8'b0;
            data_reg[3] <= 8'b0;
            count <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            valid_out <= 1'b0;  // Default to 0
            
            if (valid_in) begin
                // Shift in new data
                data_reg[3] <= data_reg[2];
                data_reg[2] <= data_reg[1];
                data_reg[1] <= data_reg[0];
                data_reg[0] <= data_in;
                
                // Update counter
                if (count == 2'b11) begin
                    count <= 2'b0;
                    // Output sum4 when 4th input arrives
                    data_out <= sum4;
                    valid_out <= 1'b1;
                end else begin
                    count <= count + 1;
                end
            end
            
            // Keep current sum available at output
            case (count)
                2'b00: data_out <= sum1;
                2'b01: data_out <= sum2;
                2'b10: data_out <= sum3;
                2'b11: data_out <= sum4;
            endcase
        end
    end

endmodule
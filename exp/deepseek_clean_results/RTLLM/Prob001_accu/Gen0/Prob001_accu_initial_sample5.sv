module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Counter for tracking valid inputs (0-3)
    reg [9:0] accumulator;  // Accumulator for sum (needs 10 bits for 4*255 max)
    reg [9:0] sum_reg;      // Register to hold the final sum

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            accumulator <= 10'b0;
            sum_reg <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default values
            valid_out <= 1'b0;

            if (valid_in) begin
                // Accumulate input data
                accumulator <= accumulator + data_in;
                
                // Increment counter
                if (count == 2'b11) begin
                    // When we have 4 inputs, output the sum
                    sum_reg <= accumulator + data_in;
                    valid_out <= 1'b1;
                    count <= 2'b00;
                    accumulator <= 10'b0;
                end
                else begin
                    count <= count + 1;
                end
            end
        end
    end

    // Output the accumulated sum
    always @(*) begin
        data_out = sum_reg;
    end

endmodule
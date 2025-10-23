module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Binary counter (0-3)
    reg [9:0] accumulator;  // Shared accumulator/output register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            accumulator <= 10'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;

            // Only process when valid input arrives
            if (valid_in) begin
                // Update accumulator
                accumulator <= accumulator + data_in;
                
                // Check if we've collected 4 samples
                if (count == 2'b11) begin
                    // Output accumulated result
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    // Reset for next accumulation cycle
                    accumulator <= 10'b0;
                    count <= 2'b00;
                end
                else begin
                    // Increment sample counter
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
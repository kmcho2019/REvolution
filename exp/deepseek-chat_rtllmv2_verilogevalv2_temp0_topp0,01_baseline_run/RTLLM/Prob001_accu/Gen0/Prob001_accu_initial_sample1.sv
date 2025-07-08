module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;      // 2-bit counter (0-3)
    reg [9:0] sum;        // Accumulator (8-bit x4 needs 10 bits)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            sum <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;

            if (valid_in) begin
                // Accumulate input data
                sum <= sum + data_in;
                
                if (count == 2'b11) begin
                    // When we have 4 inputs
                    data_out <= sum + data_in;  // Final sum
                    valid_out <= 1'b1;          // Pulse valid_out
                    sum <= 10'b0;               // Reset accumulator
                    count <= 2'b00;              // Reset counter
                end
                else begin
                    count <= count + 1'b1;       // Increment counter
                end
            end
        end
    end

endmodule
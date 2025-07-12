module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default value for valid_out (pulse for one cycle)
            valid_out <= 1'b0;

            if (valid_in) begin
                // Accumulate input data
                accumulator <= accumulator + data_in;
                
                if (count == 2'b11) begin
                    // When we have 4 inputs, output the sum
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    // Reset counter and accumulator
                    count <= 2'b00;
                    accumulator <= 10'b0;
                end
                else begin
                    // Increment counter
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
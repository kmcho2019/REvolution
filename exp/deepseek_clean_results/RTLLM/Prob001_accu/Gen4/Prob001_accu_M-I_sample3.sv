module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;         // Counter for valid inputs (0-3)
    reg valid_in_d;          // Registered version of valid_in
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            valid_in_d <= 1'b0;
        end else begin
            // Register valid_in to reduce glitches
            valid_in_d <= valid_in;
            
            // Default outputs
            valid_out <= 1'b0;
            
            if (valid_in_d) begin
                if (count == 2'b11) begin
                    // Output accumulated result (data_out already contains sum of first 3 inputs)
                    data_out <= data_out + data_in;
                    valid_out <= 1'b1;
                    count <= 2'b00;
                end else begin
                    // Accumulate input data
                    if (count == 2'b00) begin
                        // First input - store directly
                        data_out <= {2'b00, data_in};
                    end else begin
                        // Subsequent inputs - add to accumulator
                        data_out <= data_out + data_in;
                    end
                    count <= count + 1;
                end
            end
        end
    end

endmodule
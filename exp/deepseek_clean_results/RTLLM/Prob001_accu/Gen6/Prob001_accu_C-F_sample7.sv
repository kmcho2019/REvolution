module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;          // 0-3 counter
    reg [9:0] accumulator;     // Running sum
    reg valid_in_reg;          // Registered valid_in for timing

    // State tracking
    wire last_input = (count == 2'b11) & valid_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            valid_in_reg <= 1'b0;
        end else begin
            // Register valid_in for better timing
            valid_in_reg <= valid_in;

            // Default outputs
            valid_out <= 1'b0;

            // Only update when we have valid input
            if (valid_in_reg) begin
                if (last_input) begin
                    // Final accumulation and output
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    
                    // Reset for next group
                    count <= 2'b00;
                    accumulator <= 10'b0;
                end else begin
                    // Intermediate accumulation
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
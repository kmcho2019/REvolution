module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // 2-bit counter (0-3)
    reg [9:0] accumulator;  // 10-bit accumulator
    reg [7:0] input_reg;    // Registered input for pipelining

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            input_reg <= 8'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            
            // Register input for pipelining
            if (valid_in) begin
                input_reg <= data_in;
                
                // Accumulate when valid
                if (count == 2'b11) begin
                    // Final accumulation and output
                    data_out <= accumulator + input_reg;
                    valid_out <= 1'b1;
                    accumulator <= 10'b0;
                    count <= 2'b00;
                end
                else begin
                    // Intermediate accumulation
                    accumulator <= accumulator + input_reg;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
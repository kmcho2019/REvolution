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
    reg [7:0] input_reg;
    reg gated_clock;

    // Clock gating logic
    always @(*) begin
        gated_clock = clk & (valid_in | (count != 0));
    end

    always @(posedge gated_clock or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            accumulator <= 10'b0;
            input_reg <= 8'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default value for valid_out (pulse for one cycle)
            valid_out <= 1'b0;

            if (valid_in) begin
                // Register input first stage
                input_reg <= data_in;
                
                if (count == 2'b11) begin
                    // Final addition and output
                    data_out <= accumulator + input_reg;
                    valid_out <= 1'b1;
                    // Reset counter and accumulator
                    count <= 2'b00;
                    accumulator <= 10'b0;
                end
                else begin
                    // Second stage addition
                    accumulator <= accumulator + input_reg;
                    // Increment counter
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
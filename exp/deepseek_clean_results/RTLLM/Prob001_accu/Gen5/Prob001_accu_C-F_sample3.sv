module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Counter for 0-3 (4 inputs)
    reg [9:0] accumulator;  // Accumulator for sum
    wire accu_clk;          // Gated clock for accumulator

    // Clock gating for accumulator to reduce power
    assign accu_clk = clk & valid_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default values
            valid_out <= 1'b0;
            
            if (valid_in) begin
                // Terminal count detection (more efficient than comparison)
                if (&count) begin
                    // On 4th input, output sum and reset
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    count <= 2'b00;
                end
                else begin
                    // Increment counter
                    count <= count + 1'b1;
                end
            end
        end
    end

    // Accumulator on gated clock
    always @(posedge accu_clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'b0;
        end
        else begin
            // Accumulate input
            accumulator <= accumulator + data_in;
        end
    end

endmodule
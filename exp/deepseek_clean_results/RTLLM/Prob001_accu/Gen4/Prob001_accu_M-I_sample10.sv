module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

    reg [1:0] count;        // Gray code counter: 00, 01, 11, 10
    reg [9:0] accumulator;  // Accumulator for sum

    // Gray code counter progression: 00->01->11->10->00
    wire [1:0] next_count;
    assign next_count = (count == 2'b10) ? 2'b00 : 
                       (count == 2'b00) ? 2'b01 :
                       (count == 2'b01) ? 2'b11 : 2'b10;

    // Terminal count detection (count == 2'b11)
    wire terminal_count = count[1] & count[0];

    // Output directly from accumulator
    assign data_out = accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            accumulator <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default values
            valid_out <= 1'b0;
            
            if (valid_in) begin
                if (terminal_count) begin
                    // On 4th input, output sum and reset
                    accumulator <= data_in; // Start new accumulation
                    valid_out <= 1'b1;
                    count <= next_count;
                end
                else begin
                    // Accumulate input and increment counter
                    accumulator <= accumulator + data_in;
                    count <= next_count;
                end
            end
        end
    end

endmodule
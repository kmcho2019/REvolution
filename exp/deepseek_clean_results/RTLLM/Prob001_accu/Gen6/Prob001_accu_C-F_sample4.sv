module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Gray coded counter
    reg [9:0] accumulator;  // Shared accumulator/output register
    wire terminal_count;    // Terminal count detection

    // Gray code counter values: 00->01->11->10
    // Terminal count is when count == 2'b10 (third input)
    assign terminal_count = count[1] & ~count[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            accumulator <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Default valid_out to 0
            valid_out <= 1'b0;

            if (valid_in) begin
                if (terminal_count) begin
                    // On 4th input, output sum and reset
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'b0;
                    count <= 2'b00;  // Reset to Gray code 00
                end
                else begin
                    // Accumulate input and increment Gray counter
                    accumulator <= accumulator + data_in;
                    case (count)
                        2'b00: count <= 2'b01;
                        2'b01: count <= 2'b11;
                        2'b11: count <= 2'b10;
                        default: count <= 2'b00;
                    endcase
                end
            end
        end
    end

endmodule
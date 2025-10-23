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
    wire terminal_count;    // Terminal count detection

    assign terminal_count = &count;  // count == 2'b11

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
                    count <= 2'b00;
                end
                else begin
                    // Accumulate input and increment counter
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
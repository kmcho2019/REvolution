module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;  // Gray-coded counter (00, 01, 11, 10)
    reg [9:0] accumulator;
    wire [9:0] next_sum;
    wire terminal_count;

    // Gray code terminal count detection (count == 2'b10)
    assign terminal_count = count[1] & ~count[0];
    assign next_sum = accumulator + data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;  // Default value

            if (valid_in) begin
                // Update accumulator
                accumulator <= next_sum;

                // Gray code counter progression: 00->01->11->10->00
                case (count)
                    2'b00: count <= 2'b01;
                    2'b01: count <= 2'b11;
                    2'b11: count <= 2'b10;
                    2'b10: begin
                        count <= 2'b00;
                        data_out <= next_sum;
                        valid_out <= 1'b1;
                    end
                endcase
            end
        end
    end

endmodule
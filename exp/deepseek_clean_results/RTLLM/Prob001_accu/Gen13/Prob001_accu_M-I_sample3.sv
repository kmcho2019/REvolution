module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

    reg [1:0] count_gray;   // Gray code counter (00,01,11,10)
    reg [9:0] accumulator;  // Accumulator for sum
    reg [7:0] data_reg;     // Pipeline register for data_in

    // Gray code increment function
    function [1:0] gray_inc;
        input [1:0] gray;
        begin
            case(gray)
                2'b00: gray_inc = 2'b01;
                2'b01: gray_inc = 2'b11;
                2'b11: gray_inc = 2'b10;
                2'b10: gray_inc = 2'b00;
                default: gray_inc = 2'b00;
            endcase
        end
    endfunction

    // Terminal count detection (count == 3 in Gray code is 2'b11)
    wire terminal_count = (count_gray == 2'b11);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_gray <= 2'b00;
            accumulator <= 10'b0;
            data_reg <= 8'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Pipeline register for data_in
            if (valid_in) begin
                data_reg <= data_in;
            end

            // Clock gating for accumulator
            if (valid_in) begin
                if (terminal_count) begin
                    // Final accumulation and output
                    accumulator <= {2'b00, data_reg} + data_in; // Only 9-bit addition needed
                    valid_out <= 1'b1;
                    count_gray <= 2'b00;
                end
                else begin
                    // Intermediate accumulation
                    accumulator <= accumulator + {2'b00, data_reg};
                    count_gray <= gray_inc(count_gray);
                    valid_out <= 1'b0;
                end
            end
            else begin
                valid_out <= 1'b0;
            end
        end
    end

    // Direct output from accumulator
    assign data_out = accumulator;

endmodule
module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // Gray-coded counter state encoding
    // 00 -> 0, 01 -> 1, 11 -> 2, 10 -> 3
    reg [1:0] count_gray;
    reg [9:0] accumulator;
    reg       acc_update_en;

    // Convert Gray to binary for count comparisons
    function [1:0] gray2bin(input [1:0] g);
        case (g)
            2'b00: gray2bin = 2'd0;
            2'b01: gray2bin = 2'd1;
            2'b11: gray2bin = 2'd2;
            2'b10: gray2bin = 2'd3;
            default: gray2bin = 2'd0;
        endcase
    endfunction

    // Convert binary to Gray for next state
    function [1:0] bin2gray(input [1:0] b);
        bin2gray = (b >> 1) ^ b;
    endfunction

    // Next state logic for Gray counter increment by 1
    wire [1:0] count_bin = gray2bin(count_gray);
    wire [1:0] count_bin_next = count_bin + (valid_in ? 1 : 0);
    wire [1:0] count_gray_next = bin2gray(count_bin_next);

    // Determine if this is the 4th valid input (count_bin == 3 before increment)
    wire is_last_input = (count_bin == 2'd3) && valid_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator  <= 10'd0;
            count_gray   <= 2'b00;
            valid_out    <= 1'b0;
            data_out     <= 10'd0;
            acc_update_en <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default deassert

            // Update counter only when valid_in
            if (valid_in) begin
                count_gray <= count_gray_next;

                if (is_last_input) begin
                    // On 4th data input, output sum + current data and reset accumulator
                    data_out  <= accumulator + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    acc_update_en <= 1'b0;
                end else begin
                    // Accumulate data_in
                    accumulator <= accumulator + data_in;
                    acc_update_en <= 1'b1;
                end
            end else begin
                // No valid input, keep count and accumulator unchanged
                acc_update_en <= 1'b0;
            end
        end
    end

endmodule
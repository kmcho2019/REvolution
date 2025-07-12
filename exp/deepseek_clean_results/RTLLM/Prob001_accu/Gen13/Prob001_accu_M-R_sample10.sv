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
    wire [9:0] next_accumulator = accumulator + data_in;
    wire count_full = (count == 2'b11);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            // Update accumulator and counter when valid input
            if (valid_in) begin
                accumulator <= count_full ? data_in : next_accumulator;
                count <= count + 1'b1;
            end

            // Generate output when we've accumulated 4 values
            valid_out <= valid_in && count_full;
            if (valid_in && count_full) begin
                data_out <= next_accumulator;
            end
        end
    end

endmodule
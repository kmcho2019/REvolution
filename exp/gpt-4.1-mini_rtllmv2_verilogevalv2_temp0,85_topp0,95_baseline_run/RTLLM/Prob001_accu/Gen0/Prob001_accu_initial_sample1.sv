module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;  // counts from 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 2'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default de-assert valid_out
            if (valid_in) begin
                accumulator <= accumulator + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    // on the 4th valid input, output sum and assert valid_out
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule
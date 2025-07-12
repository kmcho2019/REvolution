module accu (
    input              clk,
    input              rst_n,
    input       [7:0]  data_in,
    input              valid_in,
    output reg         valid_out,
    output reg [9:0]   data_out
);

    reg [1:0]  count;          // counts from 0 to 3 (for 4 inputs)
    reg [9:0]  accumulator;    // sum of input data

    wire [9:0] sum_next = accumulator + data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 2'd0;
            accumulator <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default low

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th data input, output sum
                    data_out  <= sum_next;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                    accumulator <= 10'd0;
                end else begin
                    accumulator <= sum_next;
                    count <= count + 1;
                end
            end
        end
    end

endmodule
module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    reg [1:0]  count;
    reg [9:0]  sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            sum       <= 10'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default output pulse low each cycle

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th data input, output accumulated sum plus current data_in
                    data_out  <= sum + data_in;
                    valid_out <= 1'b1;
                    sum       <= 10'd0;  // reset sum after output
                    count     <= 2'd0;   // reset count after 4 inputs
                end else begin
                    sum   <= sum + data_in;  // accumulate sum
                    count <= count + 1'b1;   // increment count
                end
            end
        end
    end

endmodule
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
    reg [9:0]  sum_next;
    reg        output_ready;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count        <= 2'd0;
            sum          <= 10'd0;
            data_out     <= 10'd0;
            valid_out    <= 1'b0;
            output_ready <= 1'b0;
            sum_next     <= 10'd0;
        end else begin
            valid_out <= 1'b0;

            // Output stage: when output_ready is asserted, output sum_next and valid_out for 1 cycle
            if (output_ready) begin
                data_out  <= sum_next;
                valid_out <= 1'b1;
                output_ready <= 1'b0;
                sum <= 10'd0;
                count <= 2'd0;
            end else if (valid_in) begin
                // Accumulate input data
                sum_next <= sum + data_in;
                if (count == 2'd3) begin
                    output_ready <= 1'b1;
                end else begin
                    sum <= sum + data_in;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
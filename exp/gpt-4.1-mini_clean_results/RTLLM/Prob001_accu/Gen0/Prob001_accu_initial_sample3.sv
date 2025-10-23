module accu (
    input              clk,
    input              rst_n,
    input       [7:0]  data_in,
    input              valid_in,
    output reg         valid_out,
    output reg [9:0]   data_out
);

    reg [1:0]  count;          // count from 0 to 4
    reg [9:0]  accumulator;    // to accumulate sum of four 8-bit inputs

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 2'b0;
            accumulator <= 10'b0;
            data_out    <= 10'b0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default 0 each cycle

            if (valid_in) begin
                accumulator <= accumulator + data_in;
                count <= count + 1;

                if (count == 2'd3) begin
                    // On receiving the 4th data (count=3, next becomes 4)
                    data_out  <= accumulator + data_in; // sum of four inputs
                    valid_out <= 1'b1;
                    count     <= 2'b0;
                    accumulator <= 10'b0;
                end
            end
        end
    end

endmodule
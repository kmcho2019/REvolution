module accu (
    input          clk,
    input          rst_n,
    input  [7:0]   data_in,
    input          valid_in,
    output reg     valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;          // Counts from 0 to 4
    reg [9:0] accumulator;    // Holds sum of inputs

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 2'd0;
            accumulator <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default 0 each cycle

            if (valid_in) begin
                accumulator <= accumulator + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    // This is the 4th data input (count starts from 0)
                    data_out  <= accumulator + data_in; // final sum
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                    accumulator <= 10'd0;
                end
            end
        end
    end

endmodule
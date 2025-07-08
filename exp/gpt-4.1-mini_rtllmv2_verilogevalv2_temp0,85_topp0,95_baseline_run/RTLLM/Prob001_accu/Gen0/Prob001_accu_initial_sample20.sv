module accu (
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    output reg          valid_out,
    output reg  [9:0]   data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;  // to count 0 to 3 valid inputs (4 inputs total)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 2'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default to 0 every cycle

            if (valid_in) begin
                accumulator <= accumulator + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    // 4th data_in received: output accumulated sum
                    data_out <= accumulator + data_in;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule
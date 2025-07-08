module accu (
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output reg        valid_out,
    output reg [9:0]  data_out
);

    reg [1:0]  count;         // count from 0 to 3 (for 4 inputs)
    reg [9:0]  accumulator;   // 10-bit accumulator to hold sum of 4 x 8-bit inputs

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 2'b00;
            accumulator <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default to zero every cycle
            if (valid_in) begin
                accumulator <= accumulator + data_in;
                if (count == 2'd3) begin
                    // 4th data received, output result next cycle
                    data_out  <= accumulator + data_in;
                    valid_out <= 1'b1;
                    count     <= 2'b00;
                    accumulator <= 10'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
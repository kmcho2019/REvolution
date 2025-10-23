module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    reg [7:0]  data_buf [3:0];  // buffer to store 4 data inputs
    reg [1:0]  count;

    integer i;
    reg [10:0] sum_all; // wider to prevent overflow during summation

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            for (i = 0; i < 4; i = i + 1)
                data_buf[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0; // default

            if (valid_in) begin
                data_buf[count] <= data_in;
                if (count == 2'd3) begin
                    // sum all 4 buffered inputs including current one
                    sum_all = 0;
                    for (i = 0; i < 4; i = i + 1) begin
                        sum_all = sum_all + data_buf[i];
                    end
                    // Also add current input (already stored at count=3)
                    // Actually data_buf[3] = data_in, included in sum_all
                    // So sum_all already includes current data_in

                    data_out  <= sum_all[9:0]; // output lower 10 bits
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                    // Clear buffer for next batch
                    for (i = 0; i < 4; i = i + 1)
                        data_buf[i] <= 8'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    // Shift register to hold 4 data inputs
    reg [7:0] data_buf [0:3];
    reg [1:0] count;  // count number of valid inputs (0 to 3)

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            // Clear buffer on reset
            for (i=0; i<4; i=i+1) begin
                data_buf[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0;  // Default no output pulse

            if (valid_in) begin
                // Shift in new data: move older to higher index
                data_buf[3] <= data_buf[2];
                data_buf[2] <= data_buf[1];
                data_buf[1] <= data_buf[0];
                data_buf[0] <= data_in;

                if (count == 2'd3) begin
                    // 4th valid data received, sum all 4 stored inputs
                    // Perform parallel addition combinationally here
                    data_out <= data_buf[3] + data_buf[2] + data_buf[1] + data_in;
                    valid_out <= 1'b1;
                    count <= 2'd0; // Reset count after 4 inputs
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
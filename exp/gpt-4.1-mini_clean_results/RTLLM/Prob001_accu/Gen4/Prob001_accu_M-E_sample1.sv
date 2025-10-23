module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    reg [7:0] buf0, buf1, buf2, buf3;
    reg [1:0] count;

    // Shift data into the buffer when valid_in is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buf0 <= 8'd0;
            buf1 <= 8'd0;
            buf2 <= 8'd0;
            buf3 <= 8'd0;
            count <= 2'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end else begin
            valid_out <= 1'b0;  // default low

            if (valid_in) begin
                // Shift left and insert new data at buf0
                buf3 <= buf2;
                buf2 <= buf1;
                buf1 <= buf0;
                buf0 <= data_in;

                if (count == 2'd3) begin
                    // When 4th data arrives, output sum and reset count
                    data_out <= buf3 + buf2 + buf1 + data_in; 
                    valid_out <= 1'b1;
                    count <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
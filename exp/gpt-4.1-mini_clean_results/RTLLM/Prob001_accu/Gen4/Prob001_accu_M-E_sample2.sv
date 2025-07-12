module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // Shift register to hold up to 4 inputs
    reg [7:0] data_buf [0:3];
    reg [1:0] count;

    integer i;
    reg [9:0] sum_comb;

    always @(posedge clk) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            // Clear data buffer for good measure
            for (i = 0; i < 4; i = i + 1) begin
                data_buf[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // default no output

            if (valid_in) begin
                // Shift left existing data, insert new at index 0
                data_buf[3] <= data_buf[2];
                data_buf[2] <= data_buf[1];
                data_buf[1] <= data_buf[0];
                data_buf[0] <= data_in;

                if (count == 2'd3) begin
                    // On 4th valid input, sum all stored inputs combinationally
                    sum_comb = data_buf[0] + data_buf[1] + data_buf[2] + data_in;
                    data_out <= sum_comb;
                    valid_out <= 1'b1;
                    count <= 2'd0; // reset count for next batch
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
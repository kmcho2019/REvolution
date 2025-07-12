module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_buf [3:0];  // FIFO to hold 4 data samples
    reg [1:0] data_count;      // Counts how many valid data have been collected

    wire [9:0] sum_0_1;        // sum of data_buf[0] + data_buf[1]
    wire [9:0] sum_2_3;        // sum of data_buf[2] + data_buf[3]
    wire [9:0] sum_all;        // total sum

    // Sum pairs extended to 10 bits to prevent overflow:
    assign sum_0_1 = {2'b00, data_buf[0]} + {2'b00, data_buf[1]};
    assign sum_2_3 = {2'b00, data_buf[2]} + {2'b00, data_buf[3]};
    assign sum_all = sum_0_1 + sum_2_3;

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_count <= 2'd0;
            valid_out  <= 1'b0;
            data_out   <= 10'd0;
            // Initialize data buffer to 0
            for (i = 0; i < 4; i = i + 1)
                data_buf[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0; // default no valid output

            if (valid_in) begin
                // Shift data in fifo style: oldest data discarded, new data at index 0
                data_buf[3] <= data_buf[2];
                data_buf[2] <= data_buf[1];
                data_buf[1] <= data_buf[0];
                data_buf[0] <= data_in;

                if (data_count == 2'd3) begin
                    // When 4 data accumulated, output sum of all 4 data
                    data_out  <= sum_all;
                    valid_out <= 1'b1;
                    data_count <= 2'd0;
                end else begin
                    data_count <= data_count + 1'b1;
                end
            end
        end
    end

endmodule
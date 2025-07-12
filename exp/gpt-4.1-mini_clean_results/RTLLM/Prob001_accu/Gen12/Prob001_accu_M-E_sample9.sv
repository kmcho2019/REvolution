module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_shift [0:3];  // 4-entry shift register for inputs
    reg [1:0] count;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count      <= 2'd0;
            valid_out  <= 1'b0;
            data_out   <= 10'd0;
            for (i = 0; i < 4; i = i +1)
                data_shift[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0; // Default no output pulse

            if (valid_in) begin
                // Shift in new data
                data_shift[0] <= data_in;
                data_shift[1] <= data_shift[0];
                data_shift[2] <= data_shift[1];
                data_shift[3] <= data_shift[2];

                if (count == 2'd3) begin
                    // Sum all 4 stored inputs + current input data_in is already in data_shift[0]
                    // But since we shifted first, the oldest data is in data_shift[3]
                    // So sum: data_shift[0] + data_shift[1] + data_shift[2] + data_shift[3]
                    data_out  <= data_shift[0] + data_shift[1] + data_shift[2] + data_shift[3];
                    valid_out <= 1'b1;

                    count     <= 2'd0;  // Reset count
                    // Clear shift register for next batch (optional)
                    for (i = 0; i < 4; i = i +1)
                        data_shift[i] <= 8'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
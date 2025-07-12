module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_buf [3:0];  // Shift register storing 4 input data
    reg [2:0] count;           // Count valid inputs, max 4

    integer i;
    wire [9:0] sum;

    // Combinational addition of 4 stored values, zero-extend each to 10 bits
    assign sum = data_buf[0] + data_buf[1] + data_buf[2] + data_buf[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 3'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            // Clear data buffer
            for (i = 0; i < 4; i = i + 1)
                data_buf[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0;  // Default no output

            if (valid_in) begin
                if (count < 3'd4) begin
                    // Shift new input in buffer: shift left, insert data_in at data_buf[0]
                    data_buf[3] <= data_buf[2];
                    data_buf[2] <= data_buf[1];
                    data_buf[1] <= data_buf[0];
                    data_buf[0] <= data_in;
                    count <= count + 1'b1;
                end
                // When count reaches 4 after this input, output sum next cycle
            end

            if (count == 3'd4) begin
                data_out  <= sum;    // Output accumulated sum
                valid_out <= 1'b1;   // Output valid pulse
                count     <= 3'd0;   // Reset counter for next batch
                // data_buf can retain current data or reset; no harm retaining
            end
        end
    end

endmodule
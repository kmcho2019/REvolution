module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_buffer [3:0];  // Buffer to store up to 4 inputs
    reg [1:0] count;

    // Combinational sum of buffered data
    wire [9:0] sum;
    assign sum = data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];

    integer i;

    always @(posedge clk) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            // Clear buffer on reset
            for (i = 0; i < 4; i = i + 1) begin
                data_buffer[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0;  // default

            if (valid_in) begin
                // Shift existing data and insert new data at the end
                data_buffer[0] <= data_buffer[1];
                data_buffer[1] <= data_buffer[2];
                data_buffer[2] <= data_buffer[3];
                data_buffer[3] <= data_in;

                if (count == 2'd3) begin
                    // After storing 4th input, output sum and reset count
                    data_out  <= sum;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
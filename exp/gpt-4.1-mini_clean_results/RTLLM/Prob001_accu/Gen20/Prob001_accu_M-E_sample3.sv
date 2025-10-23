module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_buffer [0:3];  // store last 4 inputs
    reg [1:0] count;

    integer i;

    // Combinational sum of four inputs
    wire [9:0] sum_all;
    assign sum_all = data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            count     <= 2'd0;
            data_out  <= 10'd0;
            // Clear data buffer
            for (i = 0; i < 4; i = i + 1)
                data_buffer[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0;  // default no valid pulse

            if (valid_in) begin
                // Shift new data into buffer
                data_buffer[3] <= data_buffer[2];
                data_buffer[2] <= data_buffer[1];
                data_buffer[1] <= data_buffer[0];
                data_buffer[0] <= data_in;

                if (count == 2'd3) begin
                    // On 4th input, output sum of all buffered inputs (including new one)
                    data_out  <= sum_all;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                    // Optionally clear buffer after output for clean start
                    for (i = 0; i < 4; i = i + 1)
                        data_buffer[i] <= 8'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
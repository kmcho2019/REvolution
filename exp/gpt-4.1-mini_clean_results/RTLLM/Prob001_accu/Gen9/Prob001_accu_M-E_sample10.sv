module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_buffer [3:0];
    reg [1:0] count;

    integer i;
    reg [10:0] sum_temp; // wider to prevent overflow during summation

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
            for (i = 0; i < 4; i = i + 1)
                data_buffer[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0;
            if (valid_in) begin
                // Shift in new data
                data_buffer[0] <= data_in;
                data_buffer[1] <= data_buffer[0];
                data_buffer[2] <= data_buffer[1];
                data_buffer[3] <= data_buffer[2];

                if (count == 2'd3) begin
                    // Calculate sum of 4 stored values + new input (which is data_buffer[0])
                    // Actually data_buffer[0] now has new data_in, so sum all 4 data_buffer elements
                    // data_buffer now holds the latest 4 inputs with data_in at data_buffer[0]
                    // sum = data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];
                    sum_temp = data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];
                    data_out <= sum_temp[9:0];
                    valid_out <= 1'b1;
                    count <= 2'd0;
                    // Optionally clear buffer for clarity (not strictly needed)
                    for (i = 0; i < 4; i = i + 1)
                        data_buffer[i] <= 8'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
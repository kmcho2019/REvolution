module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // Storage for up to 4 inputs
    reg [7:0] data_buffer [3:0];
    reg [1:0] count;

    integer i;

    // Input capturing and counting
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
                data_buffer[count] <= data_in;
                count <= count + 1'b1;
            end

            if (count == 2'd4) begin
                // This state should not be reached, count max is 3, so we guard output on count==3 below
                // included for safety
                count <= 2'd0;
            end

            if (count == 2'd3 && valid_in) begin
                // When the 4th data arrives, sum all 4 stored inputs combinationally
                // data_buffer[0..2] hold previous 3 inputs, data_in is 4th input
                // Use combinational adder tree for sum
                valid_out <= 1'b1;
                // Sum calculation combinationally
                data_out <= data_buffer[0] + data_buffer[1] + data_buffer[2] + data_in;
                count <= 2'd0;  // reset for next batch
            end
        end
    end

endmodule
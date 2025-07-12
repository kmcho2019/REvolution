module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // Storage for 4 input samples
    reg [7:0] data_buffer [0:3];
    reg [1:0] count;

    // Summation wire
    wire [9:0] sum;

    // Combinational sum of four 8-bit values, zero-extended to 10 bits each
    assign sum = data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            count     <= 2'd0;
            // Clear buffer registers
            for (i = 0; i < 4; i = i + 1) begin
                data_buffer[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0;  // default no output pulse

            if (valid_in) begin
                // Shift data_buffer left and insert new data at the end
                data_buffer[0] <= data_buffer[1];
                data_buffer[1] <= data_buffer[2];
                data_buffer[2] <= data_buffer[3];
                data_buffer[3] <= data_in;

                if (count == 2'd3) begin
                    // On 4th valid input, output sum and assert valid_out
                    data_out  <= sum;
                    valid_out <= 1'b1;
                    count     <= 2'd0;  // Reset counter for next batch
                end else begin
                    count <= count + 1'b1;
                end
            end
            // If valid_in is low, no state change
        end
    end

endmodule
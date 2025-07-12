module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_buffer [3:0]; // buffer to hold 4 data inputs
    reg [1:0] count;

    // Summation wires
    wire [9:0] sum0 = data_buffer[0] + data_buffer[1];         // sum first two entries
    wire [9:0] sum1 = data_buffer[2] + data_buffer[3];         // sum last two entries
    wire [9:0] total_sum = sum0 + sum1;                         // total sum of four entries

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            // initialize data_buffer to zero
            for (i=0; i<4; i=i+1)
                data_buffer[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0; // default: no output this cycle

            if (valid_in) begin
                data_buffer[count] <= data_in;
                if (count == 2'd3) begin
                    // 4 inputs received, output accumulated sum
                    data_out  <= total_sum;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
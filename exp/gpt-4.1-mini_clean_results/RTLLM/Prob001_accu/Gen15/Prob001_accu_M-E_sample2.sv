module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // Storage for up to 4 data inputs
    reg [7:0] data_buffer [3:0];
    reg [1:0] count;

    // Combinational sum of all 4 buffer entries (updated only at output cycle)
    wire [9:0] sum_all;

    assign sum_all = data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            count     <= 2'd0;
            for (i = 0; i < 4; i = i + 1)
                data_buffer[i] <= 8'd0;
        end else begin
            valid_out <= 1'b0; // default: no output pulse

            if (valid_in) begin
                data_buffer[count] <= data_in; // store input at count index
                if (count == 2'd3) begin
                    // On 4th input, output accumulated sum of stored inputs plus current input (4 total)
                    // But data_in is already stored at data_buffer[3], sum_all uses stored values only
                    data_out  <= sum_all;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
            // if valid_in=0, hold state
        end
    end

endmodule
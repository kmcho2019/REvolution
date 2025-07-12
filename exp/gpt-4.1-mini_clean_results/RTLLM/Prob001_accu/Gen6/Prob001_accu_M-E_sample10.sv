module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_shift [3:0];  // 4-entry shift register for input data
    reg [1:0] count;

    integer i;
    wire [9:0] sum;

    // Combinational addition of the 4 stored data
    assign sum = data_shift[0] + data_shift[1] + data_shift[2] + data_shift[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            for (i = 0; i < 4; i = i +1) begin
                data_shift[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // default to 0

            if (valid_in) begin
                // Shift data to make room for new input
                data_shift[3] <= data_shift[2];
                data_shift[2] <= data_shift[1];
                data_shift[1] <= data_shift[0];
                data_shift[0] <= data_in;

                if (count == 2'd3) begin
                    // On 4th valid data input, output sum of the 4 collected data
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
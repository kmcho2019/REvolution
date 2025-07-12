module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] fifo [3:0]; // 4-entry shift register for inputs
    reg [2:0] count;      // count up to 4

    integer i;
    wire [9:0] sum_4;

    // Combinational sum of all 4 fifo entries
    assign sum_4 = fifo[0] + fifo[1] + fifo[2] + fifo[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                fifo[i] <= 8'd0;
            count <= 3'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;
            if (valid_in) begin
                // Shift data_in into fifo
                fifo[3] <= fifo[2];
                fifo[2] <= fifo[1];
                fifo[1] <= fifo[0];
                fifo[0] <= data_in;

                if (count == 3'd3) begin
                    // Now have 4 valid inputs, output sum
                    data_out <= sum_4;
                    valid_out <= 1'b1;
                    count <= 3'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
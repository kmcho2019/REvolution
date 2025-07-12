module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] shift_reg [0:3]; // 4-stage shift register for inputs
    reg [1:0] count;           // count valid inputs received (0 to 3)
    reg [9:0] sum;             // running sum of last 4 data inputs

    integer i;

    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                shift_reg[i] <= 8'd0;
            count      <= 2'd0;
            sum        <= 10'd0;
            data_out   <= 10'd0;
            valid_out  <= 1'b0;
        end else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                if (count < 2'd3) begin
                    // shift data in, accumulate sum, increase count
                    for (i = 3; i > 0; i = i - 1) begin
                        shift_reg[i] <= shift_reg[i-1];
                    end
                    shift_reg[0] <= data_in;

                    sum <= sum + data_in;
                    count <= count + 1'b1;
                end else begin
                    // On 4th data_in, shift out oldest, shift in new input
                    for (i = 3; i > 0; i = i - 1) begin
                        shift_reg[i] <= shift_reg[i-1];
                    end
                    shift_reg[0] <= data_in;

                    // sum = sum + new_input - oldest_input
                    sum <= sum + data_in - shift_reg[3];

                    data_out <= sum + data_in - shift_reg[3]; // output updated sum
                    valid_out <= 1'b1;
                    count <= 2'd0; // reset count to start next accumulation
                end
            end
        end
    end

endmodule
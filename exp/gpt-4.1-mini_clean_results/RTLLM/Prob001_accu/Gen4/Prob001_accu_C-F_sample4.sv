module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] accumulator;
    reg [1:0] count;
    reg [9:0] sum_temp;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
            sum_temp    <= 10'd0;
        end else begin
            valid_out <= 1'b0;  // default deassert

            if (valid_in) begin
                sum_temp = accumulator + data_in;

                if (count == 2'd3) begin
                    data_out    <= sum_temp;
                    valid_out   <= 1'b1;
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end else begin
                    accumulator <= sum_temp;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule
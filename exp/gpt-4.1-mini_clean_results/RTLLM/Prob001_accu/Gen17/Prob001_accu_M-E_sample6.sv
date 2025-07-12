module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output wire        valid_out,
    output reg  [9:0]  data_out
);

    reg [9:0] sum;
    reg [1:0] count;

    // valid_out is high when the current valid_in corresponds to the 4th data input (count == 3)
    assign valid_out = (count == 2'd3) && valid_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            sum      <= 10'd0;
            count    <= 2'd0;
            data_out <= 10'd0;
        end else begin
            if (valid_in) begin
                sum   <= sum + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    data_out <= sum + data_in; // output the sum of 4 inputs
                    sum      <= 10'd0;
                    count    <= 2'd0;
                end
            end
        end
    end

endmodule
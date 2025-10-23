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
    reg [9:0] sum_tmp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
            sum_tmp     <= 10'd0;
        end else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                sum_tmp = accumulator + data_in; // Calculate sum once

                if (count == 2'd3) begin
                    data_out  <= sum_tmp;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end else begin
                    accumulator <= sum_tmp;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
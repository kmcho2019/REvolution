module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    localparam ACCU_NUM = 4;

    reg [1:0] count;
    reg [9:0] sum;

    reg valid_out_next;
    reg [9:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 2'd0;
            sum         <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (valid_in) begin
                if (count == ACCU_NUM - 1) begin
                    // Output accumulation result
                    data_out_next  <= sum + data_in;
                    valid_out_next <= 1'b1;
                    sum            <= 10'd0;
                    count          <= 2'd0;
                end else begin
                    sum            <= sum + data_in;
                    count          <= count + 1'b1;
                    valid_out_next <= 1'b0;
                    // Keep data_out_next unchanged until next valid output
                    data_out_next  <= data_out_next;
                end
            end else begin
                // No valid input: keep outputs and sum/count stable
                valid_out_next <= 1'b0;
                data_out_next  <= data_out_next;
                sum            <= sum;
                count          <= count;
            end
        end
    end

endmodule
module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    localparam COUNT_MAX = 2'd3;

    reg [1:0]  count;
    reg [9:0]  sum;

    // Next state signals
    reg [1:0]  count_next;
    reg [9:0]  sum_next;
    reg        valid_out_next;
    reg [9:0]  data_out_next;

    always @* begin
        // Default next state assignments
        count_next     = count;
        sum_next       = sum;
        valid_out_next = 1'b0;
        data_out_next  = data_out;

        if (valid_in) begin
            if (count == COUNT_MAX) begin
                data_out_next  = sum + data_in;
                valid_out_next = 1'b1;
                sum_next       = 10'd0;
                count_next     = 2'd0;
            end else begin
                sum_next   = sum + data_in;
                count_next = count + 1'b1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            sum       <= 10'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            count     <= count_next;
            sum       <= sum_next;
            data_out  <= data_out_next;
            valid_out <= valid_out_next;
        end
    end

endmodule
module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    reg [1:0]  count;
    reg [9:0]  sum;
    wire [9:0] next_sum;

    assign next_sum = sum + data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            sum       <= 10'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default low

            if (valid_in) begin
                if (count == 2'd3) begin
                    // On receiving 4th valid input
                    data_out  <= next_sum;
                    valid_out <= 1'b1;
                    sum       <= 10'd0;
                    count     <= 2'd0;
                end else begin
                    sum   <= next_sum;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule
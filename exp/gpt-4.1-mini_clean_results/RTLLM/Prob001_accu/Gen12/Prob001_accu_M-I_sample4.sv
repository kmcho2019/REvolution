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

    // Register to hold final sum to output in next cycle
    reg [9:0] final_sum;
    reg       valid_out_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator   <= 10'd0;
            count         <= 2'd0;
            final_sum     <= 10'd0;
            valid_out_reg <= 1'b0;
            data_out      <= 10'd0;
            valid_out     <= 1'b0;
        end else begin
            valid_out_reg <= 1'b0;  // default no valid output this cycle
            if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th data input: compute final sum
                    final_sum     <= accumulator + data_in;
                    valid_out_reg <= 1'b1;
                    accumulator   <= 10'd0;
                    count         <= 2'd0;
                end else begin
                    accumulator <= accumulator + data_in;
                    count <= count + 1'b1;
                end
            end

            // Output final sum and valid_out one cycle after final_sum is loaded
            valid_out <= valid_out_reg;
            if (valid_out_reg) begin
                data_out <= final_sum;
            end
        end
    end

endmodule
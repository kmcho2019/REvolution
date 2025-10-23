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
    reg       output_pending;
    reg [9:0] sum_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator    <= 10'd0;
            count          <= 2'd0;
            data_out       <= 10'd0;
            valid_out      <= 1'b0;
            output_pending <= 1'b0;
            sum_reg        <= 10'd0;
        end else begin
            valid_out <= 1'b0;

            if (output_pending) begin
                // Output the latched sum, one cycle valid_out pulse
                data_out  <= sum_reg;
                valid_out <= 1'b1;
                output_pending <= 1'b0;
            end else if (valid_in) begin
                if (count == 2'd3) begin
                    // On 4th valid input, latch sum and assert output next cycle
                    sum_reg        <= accumulator + data_in;
                    accumulator    <= 10'd0;
                    count          <= 2'd0;
                    output_pending <= 1'b1;
                end else begin
                    // Accumulate and increment count with enable gating
                    accumulator <= accumulator + data_in;
                    count       <= count + 1'b1;
                end
            end
        end
    end

endmodule
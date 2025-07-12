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
    reg        output_pending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count          <= 2'd0;
            sum            <= 10'd0;
            data_out       <= 10'd0;
            valid_out      <= 1'b0;
            output_pending <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no output pulse each cycle

            if (output_pending) begin
                // Output the accumulated sum this cycle
                data_out  <= sum;
                valid_out <= 1'b1;
                sum       <= 10'd0;    // reset sum after output
                count     <= 2'd0;     // reset count after output
                output_pending <= 1'b0;
            end else if (valid_in) begin
                sum <= sum + data_in;
                if (count == 2'd3) begin
                    // After 4th input accumulated, set output_pending for next cycle
                    output_pending <= 1'b1;
                end
                count <= count + 1'b1;
            end
        end
    end

endmodule
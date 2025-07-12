module accu (
    input              clk,
    input              rst_n,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         valid_out,
    output reg [9:0]   data_out
);

    reg [9:0] acc;        // accumulator for sum (max 4*255=1020 < 10 bits)
    reg [1:0] count;      // count valid inputs (0 to 3)
    reg       output_flag; // flag indicating output cycle

    wire update_enable = valid_in && !output_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc         <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
            output_flag <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default no valid output

            if (output_flag) begin
                // Output the accumulated sum for one cycle
                data_out  <= acc;
                valid_out <= 1'b1;
                // Clear acc and count after output
                acc       <= 10'd0;
                count     <= 2'd0;
                output_flag <= 1'b0;
            end else if (update_enable) begin
                // Accumulate input data and count
                acc   <= acc + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    // After 4th data input received, set flag to output next cycle
                    output_flag <= 1'b1;
                end
            end
            // else if valid_in==0 or output_flag==1, hold registers (no update)
        end
    end

endmodule
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
    reg       output_ready;   // Indicates sum is ready to be output next cycle
    reg [9:0] output_reg;     // Latch accumulator sum for output stage

    always @(posedge clk) begin
        if (!rst_n) begin
            accumulator  <= 10'd0;
            count        <= 2'd0;
            valid_out    <= 1'b0;
            data_out     <= 10'd0;
            output_ready <= 1'b0;
            output_reg   <= 10'd0;
        end else begin
            valid_out <= 1'b0; // Default no valid out

            if (output_ready) begin
                // Output stage: drive output and valid_out for one cycle
                data_out  <= output_reg;
                valid_out <= 1'b1;
                output_ready <= 1'b0;
                // Reset accumulator and count after output
                accumulator <= 10'd0;
                count       <= 2'd0;
            end else if (valid_in) begin
                accumulator <= accumulator + data_in;
                count <= count + 1'b1;

                if (count == 2'd3) begin
                    // When 4th data_in arrives (count 0..3), latch sum + input for output next cycle
                    output_reg <= accumulator + data_in;
                    output_ready <= 1'b1;
                end
            end
        end
    end

endmodule
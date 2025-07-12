module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    reg [2:0] count;        // Counts number of valid inputs accumulated (0 to 4)
    reg [9:0] accumulator;  // Accumulates sum of inputs

    // Counting and accumulating inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count       <= 3'd0;
            accumulator <= 10'd0;
        end else begin
            if (valid_in) begin
                count       <= count + 3'd1;
                accumulator <= accumulator + data_in;
            end
            // When count reaches 4, it will be handled in output block
            // No else needed since count and accumulator hold their values otherwise
        end
    end

    // Output generation and valid_out signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            count     <= 3'd0;      // Ensure count resets here if needed
            accumulator <= 10'd0;   // Reset accumulator as well
        end else begin
            if (count == 3'd4) begin
                data_out  <= accumulator;
                valid_out <= 1'b1;
                count     <= 3'd0;
                accumulator <= 10'd0;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule
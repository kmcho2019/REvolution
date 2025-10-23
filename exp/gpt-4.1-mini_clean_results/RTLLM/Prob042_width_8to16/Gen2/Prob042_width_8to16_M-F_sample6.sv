module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;   // Holds first 8-bit data
    reg       data_lock_en; // Flag indicating first data stored

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            data_lock_en  <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no output unless triggered

            if (valid_in) begin
                if (!data_lock_en) begin
                    // First valid input: store it and set flag
                    data_lock    <= data_in;
                    data_lock_en <= 1'b1;
                end else begin
                    // Second valid input: concatenate and output next cycle
                    data_out     <= {data_lock, data_in};
                    valid_out    <= 1'b1;
                    data_lock_en <= 1'b0; // clear flag after output
                end
            end
            // If no valid_in, maintain state but no outputs change
        end
    end

endmodule
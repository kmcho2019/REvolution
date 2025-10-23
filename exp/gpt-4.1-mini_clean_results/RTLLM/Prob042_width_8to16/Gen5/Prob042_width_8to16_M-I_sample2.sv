module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;          // Stores first incoming byte
    reg       half_full;          // Indicates if first byte is stored (1) or not (0)

    reg       valid_out_reg;      // Registered valid flag for output
    reg [15:0] data_out_reg;      // Registered concatenated data

    // Capture first byte or form 16-bit output when second byte arrives
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            half_full     <= 1'b0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0; // Default no valid output this cycle

            if (valid_in) begin
                if (!half_full) begin
                    // Store first byte, wait for second
                    data_lock <= data_in;
                    half_full <= 1'b1;
                end else begin
                    // Second byte arrived: concatenate and mark output valid next cycle
                    data_out_reg  <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;
                    half_full    <= 1'b0; // Clear flag to wait for next first byte
                end
            end

            // Output pipeline: valid_out and data_out appear one clock cycle after second byte arrival
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule
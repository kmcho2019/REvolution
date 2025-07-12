module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output reg     valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;       // Holds the first byte
    reg       has_first_byte;  // Flag indicating first byte stored

    // Registers to hold output data and valid flag delayed by 1 cycle after second input
    reg valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'b0;
            has_first_byte <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'b0;
            valid_out_next <= 1'b0;
            data_out_next  <= 16'b0;
        end else begin
            valid_out  <= valid_out_next;
            data_out   <= data_out_next;

            // Default outputs to zero and invalid each cycle, unless updated below
            valid_out_next <= 1'b0;
            data_out_next  <= 16'b0;

            if (valid_in) begin
                if (!has_first_byte) begin
                    // Store first byte (to high bits), set flag
                    data_lock      <= data_in;
                    has_first_byte <= 1'b1;
                end else begin
                    // Second byte arrived: prepare output one cycle later
                    // Concatenate data_lock (first byte) as high 8 bits and data_in as low 8 bits
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;

                    // Clear flag to accept next pair starting next cycle
                    has_first_byte <= 1'b0;
                end
            end
        end
    end

endmodule
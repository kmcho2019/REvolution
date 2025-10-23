module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;       // Stores the first input byte
    reg [7:0] data_in_reg;     // Stores the second input byte temporarily
    reg       has_first_byte;  // Indicates if first byte has been stored
    reg       output_pending;  // Indicates output should be generated next cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            data_in_reg    <= 8'd0;
            has_first_byte <= 1'b0;
            output_pending <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            valid_out <= 1'b0; // Default: no output valid unless set below

            if (output_pending) begin
                // Output the concatenated data one cycle after second byte arrival
                data_out <= {data_lock, data_in_reg};
                valid_out <= 1'b1;
                output_pending <= 1'b0;
                has_first_byte <= 1'b0; // Clear the first byte flag after output
            end else if (valid_in) begin
                if (!has_first_byte) begin
                    // Store first byte and wait for next
                    data_lock <= data_in;
                    has_first_byte <= 1'b1;
                end else begin
                    // This is second byte: store it and prepare to output next cycle
                    data_in_reg <= data_in;
                    output_pending <= 1'b1;
                end
            end
            // If no valid_in and no output_pending, stay idle and wait
        end
    end

endmodule
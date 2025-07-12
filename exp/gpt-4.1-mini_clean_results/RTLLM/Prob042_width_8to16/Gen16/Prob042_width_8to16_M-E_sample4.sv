module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // Register to hold first byte
    reg [7:0] data_lock;
    // Flag indicating first byte is stored (1) or expecting first byte (0)
    reg       first_byte_stored;
    // Register to hold second byte for output data generation
    reg [7:0] second_byte;

    // Signal indicating that output data and valid_out should be generated next clock cycle
    reg       output_pending;

    // Stage 1: Input data handling and flags
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock        <= 8'd0;
            first_byte_stored <= 1'b0;
            second_byte      <= 8'd0;
            output_pending   <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // default deassert valid_out each cycle; will assert below if needed

            if (valid_in) begin
                if (!first_byte_stored) begin
                    // First byte arrives: store it, set flag
                    data_lock <= data_in;
                    first_byte_stored <= 1'b1;
                    output_pending <= 1'b0; // no output yet, waiting for second byte
                end else begin
                    // Second byte arrives: store it, clear flag, mark output pending
                    second_byte <= data_in;
                    first_byte_stored <= 1'b0;
                    output_pending <= 1'b1;  // output will be generated next clock cycle
                end
            end else begin
                // No valid input this cycle, keep output_pending if set for next cycle output generation
                // (It will be cleared in next block after output)
            end

            // Stage 2: Generate output on output_pending
            if (output_pending) begin
                data_out  <= {data_lock, second_byte};
                valid_out <= 1'b1;
                output_pending <= 1'b0; // clear after generating output
            end
        end
    end

endmodule
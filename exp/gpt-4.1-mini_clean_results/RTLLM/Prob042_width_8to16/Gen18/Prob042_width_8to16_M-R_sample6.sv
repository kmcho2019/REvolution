module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;     // Holds first byte
    reg [7:0] second_byte;   // Holds second byte
    reg       has_data;      // Flag indicating first byte is latched
    reg       output_pending; // Indicates output will be valid next cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            second_byte    <= 8'd0;
            has_data       <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
            output_pending <= 1'b0;
        end else begin
            valid_out <= output_pending; // valid_out asserted exactly one cycle after second byte latched

            if (valid_in) begin
                if (!has_data) begin
                    // First valid byte arrives
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                    output_pending <= 1'b0; // no output yet
                end else begin
                    // Second valid byte arrives
                    second_byte <= data_in;
                    output_pending <= 1'b1; // output will be valid next cycle
                    has_data <= 1'b0;       // reset flag to accept next pair
                end
            end else begin
                // No new input
                output_pending <= 1'b0; // clear output_pending if no second input this cycle
            end

            // Update output data one cycle after second byte latched
            if (output_pending) begin
                data_out <= {data_lock, second_byte};
            end
        end
    end

endmodule
module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;          // Holds the first 8-bit input
    reg       data_lock_en;       // Flag to indicate first data stored

    // Pipeline registers to generate outputs in the cycle after receiving second input
    reg        output_valid;
    reg [15:0] output_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            data_lock_en   <= 1'b0;
            output_valid   <= 1'b0;
            output_data    <= 16'd0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
        end else begin
            valid_out <= output_valid;  // valid_out asserted exactly one cycle

            if (output_valid) begin
                data_out <= output_data;  // Output valid data
            end else begin
                data_out <= 16'd0;        // Clear data_out when not valid (optional)
            end

            output_valid <= 1'b0; // Default clear output valid, set below if needed

            if (valid_in) begin
                if (!data_lock_en) begin
                    // First valid input: store and set flag
                    data_lock    <= data_in;
                    data_lock_en <= 1'b1;
                end else begin
                    // Second valid input: prepare output for next cycle
                    output_data  <= {data_lock, data_in};
                    output_valid <= 1'b1;
                    data_lock_en <= 1'b0; // Clear flag after second input
                end
            end
        end
    end

endmodule
module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;      // Holds first input byte
    reg        has_data;       // Flag: 1 if waiting second byte
    reg [15:0] concat_data;    // Temporary concatenated data after second input

    // Registers to generate output delayed by 1 cycle after second input
    reg        output_valid;
    reg [15:0] output_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock    <= 8'd0;
            has_data     <= 1'b0;
            concat_data  <= 16'd0;
            output_valid <= 1'b0;
            output_data  <= 16'd0;
            valid_out    <= 1'b0;
            data_out     <= 16'd0;
        end else begin
            // Default: clear valid_out, valid pulse one cycle only
            valid_out <= output_valid;
            data_out  <= output_data;

            output_valid <= 1'b0;  // Clear output valid each cycle unless set below

            if (valid_in) begin
                if (!has_data) begin
                    // First byte input: store and wait for second input
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                end else begin
                    // Second byte input: concatenate and prepare output
                    concat_data <= {data_lock, data_in};
                    has_data    <= 1'b0;

                    // Output registers set on next clock cycle (pipeline stage)
                    // Here we use non-blocking assignments but assign pipeline registers below
                end
            end

            // Pipeline output_valid and output_data one cycle after second input arrives
            // This requires detecting second input event: has_data==1 && valid_in == 1 in current cycle
            if (has_data && valid_in) begin
                // Second input just arrived this cycle (has_data was 1 before update)
                // Move concat_data to output registers next cycle
                output_valid <= 1'b1;
                output_data  <= {data_lock, data_in};
            end
        end
    end

endmodule
module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;        // stores first valid input
    reg       data_lock_valid;  // flag indicating data_lock is occupied

    reg [7:0] data_second;      // stores second valid input delayed by one cycle
    reg       output_flag;      // indicates output valid to be generated next cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock       <= 8'd0;
            data_lock_valid <= 1'b0;
            data_second     <= 8'd0;
            output_flag     <= 1'b0;
            valid_out       <= 1'b0;
            data_out        <= 16'd0;
        end else begin
            valid_out <= 1'b0; // default no output each cycle

            if (output_flag) begin
                // Generate output: concat data_lock (high 8 bits) and data_second (low 8 bits)
                data_out  <= {data_lock, data_second};
                valid_out <= 1'b1;

                // Clear output flag and stored data after output
                output_flag     <= 1'b0;
                data_lock_valid <= 1'b0;
            end

            if (valid_in) begin
                if (!data_lock_valid) begin
                    // Store first valid input in data_lock
                    data_lock       <= data_in;
                    data_lock_valid <= 1'b1;
                end else begin
                    // Second valid input arrives
                    // Store second input for output next cycle
                    data_second <= data_in;
                    output_flag <= 1'b1;
                    // Keep data_lock_valid until output_flag resets in next cycle
                end
            end
        end
    end

endmodule
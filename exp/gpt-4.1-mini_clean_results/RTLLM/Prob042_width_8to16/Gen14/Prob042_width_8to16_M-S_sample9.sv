module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       data_lock_valid;

    // Temporary registers to hold next cycle output
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock       <= 8'd0;
            data_lock_valid <= 1'b0;
            valid_out       <= 1'b0;
            data_out        <= 16'd0;
        end else begin
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            valid_out_next <= 1'b0; // Default: no output valid unless set below
            data_out_next  <= 16'd0;

            if (valid_in) begin
                if (!data_lock_valid) begin
                    // Store first valid input
                    data_lock       <= data_in;
                    data_lock_valid <= 1'b1;
                end else begin
                    // Second valid input: concatenate and output next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    data_lock_valid <= 1'b0; // Clear lock after output
                end
            end
            // If valid_in is low, no state change and no output
        end
    end

endmodule
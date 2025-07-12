module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;        // Store first input data byte
    reg       toggle;           // 0: waiting for first byte, 1: first byte stored, waiting for second
    reg [15:0] data_out_next;  // Next cycle's output data
    reg        valid_out_next;  // Next cycle's valid flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            toggle         <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
            data_out_next  <= 16'd0;
            valid_out_next <= 1'b0;
        end else begin
            // Default next cycle outputs to zero
            valid_out_next <= 1'b0;

            if (valid_in) begin
                if (toggle == 1'b0) begin
                    // Store first byte and set toggle to wait for second
                    data_lock <= data_in;
                    toggle    <= 1'b1;
                end else begin
                    // Second byte arrived: prepare next cycle's output
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    toggle         <= 1'b0;  // Ready to accept new first byte next
                end
            end

            // Register output signals from previous cycle
            valid_out <= valid_out_next;
            data_out  <= data_out_next;
        end
    end

endmodule
module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;     // Stores first byte
    reg        have_first;    // Indicates if first byte stored
    reg [15:0] data_next;     // Holds next output data
    reg        valid_next;    // Holds next cycle's valid_out

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            have_first <= 1'b0;
            data_lock  <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
            data_next  <= 16'd0;
            valid_next <= 1'b0;
        end else begin
            // Output registers update from next-stage pipeline regs
            valid_out <= valid_next;

            // Clear data_out when no valid output to avoid stale data
            data_out <= valid_next ? data_next : 16'd0;

            valid_next <= 1'b0; // default clear

            if (valid_in) begin
                if (!have_first) begin
                    // Store first valid byte
                    data_lock  <= data_in;
                    have_first <= 1'b1;
                end else begin
                    // Have first byte, form 16-bit data output next cycle
                    data_next  <= {data_lock, data_in};
                    valid_next <= 1'b1;
                    have_first <= 1'b0;
                end
            end
        end
    end

endmodule
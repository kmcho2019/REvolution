module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;
    reg        have_first;    // Indicates if first byte is stored
    reg [15:0] data_next;     // Stores concatenated data to output next cycle
    reg        valid_next;    // Valid flag for next cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            have_first <= 1'b0;
            data_lock  <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
            data_next  <= 16'd0;
            valid_next <= 1'b0;
        end else begin
            valid_out <= valid_next;
            data_out  <= valid_next ? data_next : data_out;
            valid_next <= 1'b0;

            if (valid_in) begin
                if (!have_first) begin
                    // Store first byte
                    data_lock  <= data_in;
                    have_first <= 1'b1;
                end else begin
                    // Have first byte, now form 16-bit output
                    data_next  <= {data_lock, data_in};
                    valid_next <= 1'b1;
                    have_first <= 1'b0;
                end
            end
        end
    end

endmodule
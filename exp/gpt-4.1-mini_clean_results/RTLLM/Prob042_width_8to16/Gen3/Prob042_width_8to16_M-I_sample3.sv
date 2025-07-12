module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;       // Stores first 8-bit data
    reg        data_lock_en;    // Indicates first data stored

    reg [15:0] data_out_next;   // Holds concatenated data before output
    reg        valid_out_next;  // Indicates valid_out assertion next cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock       <= 8'd0;
            data_lock_en    <= 1'b0;
            data_out        <= 16'd0;
            valid_out       <= 1'b0;
            data_out_next   <= 16'd0;
            valid_out_next  <= 1'b0;
        end else begin
            valid_out <= valid_out_next;  // Output valid_out delayed by one cycle
            data_out  <= data_out_next;   // Output data delayed by one cycle

            valid_out_next <= 1'b0;        // Default de-assert valid_out_next

            if (valid_in) begin
                if (!data_lock_en) begin
                    // First valid input: store data and set flag
                    data_lock    <= data_in;
                    data_lock_en <= 1'b1;
                end else begin
                    // Second valid input: latch concatenated data and assert valid_out next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    data_lock_en   <= 1'b0; // Clear flag after preparing output
                end
            end
        end
    end

endmodule
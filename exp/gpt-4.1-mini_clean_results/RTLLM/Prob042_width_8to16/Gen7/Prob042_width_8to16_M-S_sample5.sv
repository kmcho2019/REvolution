module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       has_data;

    // Registered outputs to produce valid_out and data_out one cycle after second valid input
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            has_data      <= 1'b0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
            valid_out_next <= 1'b0;
            data_out_next  <= 16'd0;
        end else begin
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            valid_out_next <= 1'b0;  // default no output next cycle

            if (valid_in) begin
                if (!has_data) begin
                    // store first data
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                end else begin
                    // second data received, produce output next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    has_data       <= 1'b0; // clear stored data after forming output
                end
            end
            // if no valid_in, hold registers as is, valid_out_next stays 0
        end
    end

endmodule
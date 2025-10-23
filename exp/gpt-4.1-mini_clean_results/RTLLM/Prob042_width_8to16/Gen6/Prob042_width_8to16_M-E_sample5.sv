module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;   // store first byte
    reg [7:0] data_next;   // store second byte
    reg       flag;        // 0: waiting for first byte; 1: first byte stored

    // Internal register to delay valid_out and data_out by one cycle after second byte arrival
    reg       out_valid_d;
    reg [15:0] out_data_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock   <= 8'd0;
            data_next   <= 8'd0;
            flag        <= 1'b0;
            out_valid_d <= 1'b0;
            out_data_d  <= 16'd0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
        end else begin
            // Default: clear valid_out each cycle, set only when new output is ready
            valid_out <= out_valid_d;
            data_out  <= out_data_d;

            // Handle input data
            if (valid_in) begin
                if (!flag) begin
                    // First byte received
                    data_lock <= data_in;
                    flag <= 1'b1;
                    // No output yet
                    out_valid_d <= 1'b0;
                end else begin
                    // Second byte received
                    data_next <= data_in;
                    flag <= 1'b0;
                    // Register output for next cycle
                    out_data_d  <= {data_lock, data_in};
                    out_valid_d <= 1'b1;
                end
            end else begin
                // No new input
                out_valid_d <= 1'b0;
            end
        end
    end

endmodule